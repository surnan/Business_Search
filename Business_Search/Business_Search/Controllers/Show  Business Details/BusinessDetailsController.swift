//
//  BusinessController.swift
//  Business_Search
//
//  Created by admin on 5/10/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData
import MapKit
import CoreLocation


class BusinessDetailsController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    var model = BusinessDetailsModel()
    
    var currentLocation: CLLocation?
    
    lazy var mapView: MKMapView = {
        var map = MKMapView()
        map.delegate = self
        map.isZoomEnabled = false
        map.isScrollEnabled = false
        map.mapType = .standard
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    

//    var ratingLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .darkGray
//        label.numberOfLines = -1
//        label.font = UIFont.boldSystemFont(ofSize: 20)
//        label.textAlignment = .center
//        return label
//    }()
//
//    var priceLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .darkGray
//        label.font = UIFont.boldSystemFont(ofSize: 20)
//        label.textAlignment = .center
//        return label
//    }()
//
//    var nameLabel: UILabel = {
//        let label = UILabel()
//        label.numberOfLines = -1
//        label.textAlignment = .center
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    var addressLabel: UILabel = {
//        let label = UILabel()
//        label.numberOfLines = -1
//        label.textAlignment = .center
//        return label
//    }()
//
//    var phoneNumberLabel: UILabel = {
//        let label = UILabel()
//        let text = ""
//        label.attributedText = NSAttributedString(string: text, attributes: black25textAttributes)
//        label.textAlignment = .center
//        return label
//    }()
    
    var websiteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Load Website from Yelp", for: .normal)
        return button
    }()
    
    var phoneNumberButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(phoneTapped(sender:)), for: .touchUpInside)
        return button
    }()
    
    lazy var visitYelpPageButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 12
        let attributedString = NSAttributedString(string: "Visit Yelp Page", attributes: white25textAttributes)
        button.setAttributedTitle(attributedString, for: .normal)
        button.backgroundColor = UIColor.blue
        button.addTarget(self, action: #selector(handleVisitYelpPageButton(_:)), for: .touchUpInside)
        return button
    }()
    
    
    lazy var mapItButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 12
        let attributedString = NSAttributedString(string: "         MAP IT         ", attributes: white25textAttributes)
        button.setAttributedTitle(attributedString, for: .normal)
        button.backgroundColor = UIColor.red
        button.addTarget(self, action: #selector(handlemapItButton(_:)), for: .touchUpInside)
        return button
    }()
    
    var stackViewBtm: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        return locationManager
    }()
    
    var firstAnnotation: MKPointAnnotation = {
        let annotation = MKPointAnnotation()
        return annotation
    }()
    
    var business: Business! {
        didSet {
            firstAnnotation.coordinate = CLLocationCoordinate2D(latitude: business.latitude, longitude: business.longitude)
            
            if let name = business.name {
                let attributes: [NSAttributedString.Key: Any] = [
                    .foregroundColor : UIColor.black,
                    .font: UIFont.boldSystemFont(ofSize: 28),
                ]
                model.nameLabel.attributedText = NSAttributedString(string: name, attributes: attributes)
            }
            
            if let address = business.displayAddress {
                let replaced = address.replacingOccurrences(of: "?", with: "\n")
                let attributes: [NSAttributedString.Key: Any] = [
                    .foregroundColor : UIColor.black,
                    .font: UIFont(name: "Georgia", size: 25) as Any,
                ]
                model.addressLabel.attributedText = NSAttributedString(string: replaced, attributes: attributes)
            }
            
            
            if let phoneNumber = business.displayPhone {
                let phoneText = "tel://\(phoneNumber)"
                let attributes: [NSAttributedString.Key: Any] = [
                    .foregroundColor : UIColor.blue,
                    .font: UIFont(name: "Arial", size: 25) as Any,
                    // NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
                ]
                model.phoneNumberLabel.attributedText = NSAttributedString(string: phoneText, attributes: attributes)
            }
            
            if let phoneNumber = business.displayPhone {
                let phoneText = "\(phoneNumber)"
                let attributes: [NSAttributedString.Key: Any] = [
                    .foregroundColor : UIColor.blue,
                    .font: UIFont(name: "Georgia", size: 25) as Any,
                ]
                let myNormalAttributedTitle = NSAttributedString(string: phoneText,
                                                                 attributes: attributes)
                phoneNumberButton.setAttributedTitle(myNormalAttributedTitle, for: .normal)
            }

            if let price = business.price {
                model.priceLabel.text = "Price: \(price)"
            }
            model.ratingLabel.text = "\nRating: \(business.rating)"
        }
    }
    
    @objc func handlePhoneButton(){
        print("Button Pressed")
    }
    
    
    
    
    @objc func handleVisitYelpPageButton(_ sender: UIButton){
        guard var _stringToURL = business.url else {
            UIApplication.shared.open(URL(string: "https://www.yelp.com")!)     //MediaURL = empty, load Yelp
            return
        }
        let backupURL = URL(string: "https://www.yelp.com")!                    //URL is invalid, convert string to google search query
        if _stringToURL._isValidURL {
            _stringToURL = _stringToURL._prependHTTPifNeeded()
            let url = URL(string: _stringToURL) ?? backupURL
            UIApplication.shared.open(url)
        } else {
            UIApplication.shared.open(backupURL)
        }
    }
    
    
    @objc func handlemapItButton(_ sender: UIButton){
        guard let currentLocation = locationManager.location?.coordinate else {print("Unable to get current Location"); return}
        let source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: currentLocation.latitude, longitude: currentLocation.longitude)))
        let destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: business.latitude, longitude: business.longitude)))
        source.name = "Source"
        destination.name = "Destination"
        MKMapItem.openMaps(with: [source, destination], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
    
    override func viewDidLoad() {
        locationManager.startUpdatingLocation()
        view.backgroundColor = UIColor.white
        let safe = view.safeAreaLayoutGuide
        mapView.addAnnotation(firstAnnotation)
        let viewRegion = MKCoordinateRegion(center: firstAnnotation.coordinate, latitudinalMeters: 400, longitudinalMeters: 400)
        mapView.setRegion(viewRegion, animated: false)
        [model.addressLabel, model.phoneNumberButton, model.ratingLabel, model.priceLabel].forEach{stackView.addArrangedSubview($0)}
        [visitYelpPageButton, mapItButton].forEach{stackViewBtm.addArrangedSubview($0)}
        [mapView, model.nameLabel, stackView, stackViewBtm].forEach{view.addSubview($0)}
        mapView.heightAnchor.constraint(equalTo: safe.heightAnchor, multiplier: 0.25).isActive = true
        mapView.anchor(top: safe.topAnchor, leading: safe.leadingAnchor, trailing: safe.trailingAnchor,
                       padding: .init(top: 3, left: 3, bottom: 0, right: 3))
        model.nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        model.nameLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.80).isActive = true
        model.nameLabel.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 10).isActive = true
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: model.nameLabel.bottomAnchor, constant: 15).isActive = true
        stackViewBtm.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20).isActive = true
        stackViewBtm.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackViewBtm.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.66).isActive = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "pause", style: .done, target: self, action: #selector(pauseFunc))
    }
    

    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        } else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    @objc func phoneTapped(sender: UIButton){
        print("phone tapped")
        print("title = \(sender.titleLabel?.text ?? "")")
        guard let numberString = sender.titleLabel?.text else {return}
        let number = numberString.filter("0123456789".contains)
        let call = number
        print("call --> \(call)")
        if let url = URL(string: "tel://\(call)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    @objc func pauseFunc(){
        print("")
    }
}


