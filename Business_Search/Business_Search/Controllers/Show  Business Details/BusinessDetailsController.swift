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
    
//    var phoneNumberButton: UIButton = {
//        let button = UIButton()
//        button.addTarget(self, action: #selector(phoneTapped(sender:)), for: .touchUpInside)
//        return button
//    }()

    func addHandlers(){
        model.phoneNumberButton.addTarget(self, action: #selector(phoneTapped(sender:)), for: .touchUpInside)
        model.visitYelpPageButton.addTarget(self, action: #selector(handleVisitYelpPageButton(_:)), for: .touchUpInside)
        model.mapItButton.addTarget(self, action: #selector(handlemapItButton(_:)), for: .touchUpInside)
    }
    
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
    
    var business: Business! {
        didSet {
            model.business = business
        }
    }
    
    //MARK:- Functions START
    override func viewDidLoad() {
        locationManager.startUpdatingLocation()
        model.mapView.delegate = self
        addHandlers()
        view.backgroundColor = UIColor.white
        let safe = view.safeAreaLayoutGuide
        model.mapView.addAnnotation(model.firstAnnotation)
        let viewRegion = MKCoordinateRegion(center: model.firstAnnotation.coordinate, latitudinalMeters: 400, longitudinalMeters: 400)
        model.mapView.setRegion(viewRegion, animated: false)
        [model.addressLabel, model.phoneNumberButton, model.ratingLabel, model.priceLabel].forEach{stackView.addArrangedSubview($0)}
        [model.visitYelpPageButton, model.mapItButton].forEach{stackViewBtm.addArrangedSubview($0)}
        [model.mapView, model.nameLabel, stackView, stackViewBtm].forEach{view.addSubview($0)}
        model.mapView.heightAnchor.constraint(equalTo: safe.heightAnchor, multiplier: 0.25).isActive = true
        model.mapView.anchor(top: safe.topAnchor, leading: safe.leadingAnchor, trailing: safe.trailingAnchor,
                       padding: .init(top: 3, left: 3, bottom: 0, right: 3))
        model.nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        model.nameLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.80).isActive = true
        model.nameLabel.topAnchor.constraint(equalTo: model.mapView.bottomAnchor, constant: 10).isActive = true
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
    
    @objc func pauseFunc(){ print("") }
    
    //MARK:- Handlers
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
        print("handleMapITButton")
        guard let currentLocation = locationManager.location?.coordinate else {print("Unable to get current Location"); return}
        let source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: currentLocation.latitude, longitude: currentLocation.longitude)))
        let destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: business.latitude, longitude: business.longitude)))
        source.name = "Source"
        destination.name = "Destination"
        MKMapItem.openMaps(with: [source, destination], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
}


