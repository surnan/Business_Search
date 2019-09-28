//
//  SearchByAddressController.swift
//  Business_Search
//
//  Created by admin on 5/5/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

let cornerRadiusSize: CGFloat = 5.0
let customUIHeightSize: CGFloat = 55

class SearchByAddressController: UIViewController, UITextFieldDelegate, MKMapViewDelegate, UIGestureRecognizerDelegate {
    var coordinator: PushOpen?
    
    var dataController: DataController!                 //Injected
    var possibleInsertLocationCoordinate: CLLocation!   //Injected
    var locationToForward = CLLocation()                //Pushing to newController()

    lazy var myTapGesture: UITapGestureRecognizer = {
        var gesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        gesture.delegate = self
        return gesture
    }()
    
    
    @objc func handleTap(_ sender: UITapGestureRecognizer){
        print("tap happened")
    }
    
    
    let geoCoder = CLGeocoder()

    let locationImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "pin"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        if let _ = possibleInsertLocationCoordinate {
            mapView.region = MKCoordinateRegion(center: possibleInsertLocationCoordinate.coordinate,
                                                latitudinalMeters: 500,
                                                longitudinalMeters: 500)
        }
        
        mapView.delegate = self
        mapView.isScrollEnabled = false
        return mapView
    }()
    
    var locationTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSMutableAttributedString(string: "Enter a Location", attributes: grey25textAttributes)
        textField.myStandardSetup(cornerRadiusSize: cornerRadiusSize, defaulAttributes: black25textAttributes)
        return textField
    }()
    
    
    var findLocationButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.steelBlue
        button.setTitle("FIND LOCATION", for: .normal)
        button.setTitle("Searching...", for: .selected)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(handleFindButton(_:)), for: .touchUpInside)
        button.layer.cornerRadius = cornerRadiusSize
        button.clipsToBounds = true
        return button
    }()
    
    @objc func handleFindButton(_ sender: UIButton){
        view.endEditing(true)
        geoCoder.geocodeAddressString(locationTextField.text ?? "") { [weak self] (clplacement, error) in
            guard let placemarks = clplacement, let location = placemarks.first?.location else {
                print("UNABLE to convert to CLL Coordinates")
                sender.isSelected = false
                return
            }
            self?.locationToForward = location
            DispatchQueue.main.async {[weak self] in
                guard let self = self else {return}
                let tempAnnotation = MKPointAnnotation()
                tempAnnotation.coordinate = (self.locationToForward.coordinate)
                self.mapView.addAnnotation(tempAnnotation)
                self.mapView.setCenter(tempAnnotation.coordinate, animated: false)
                let coord = self.mapView.centerCoordinate
                self.locationToForward =  CLLocation(latitude: coord.latitude, longitude: coord.longitude)
            }
        }
    }

    @objc func handleRight(){
        coordinator?.pushOpenCoordinator(userLocation: locationToForward)
    }
    
    
    func setupNavigationManu(){
        navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(handleRight))]
        /*
        navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(handleRight)),
                                              UIBarButtonItem(title: "⏸", style: .done, target: self, action: #selector(handlePause))]
        */
    }
    

    @objc func handlePause() {
        print(" mapView.centerCoordinate = \(mapView.centerCoordinate)")
    }
    
    func setupUI(){
        let stackView: UIStackView = {
            let stack = UIStackView()
            stack.axis = .vertical
            stack.alignment = .center
            stack.distribution = .fill
            stack.spacing = 15
            stack.translatesAutoresizingMaskIntoConstraints = false
            return stack
        }()
        
        [locationTextField, findLocationButton].forEach{
            $0.heightAnchor.constraint(equalToConstant: customUIHeightSize).isActive = true
            stackView.addArrangedSubview($0)
        }
        
        
        [stackView, locationImageView, mapView].forEach{view.addSubview($0)}
        NSLayoutConstraint.activate([
            locationImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            locationImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: locationImageView.bottomAnchor, constant: 10),
            
            locationTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            findLocationButton.widthAnchor.constraint(equalTo: locationTextField.widthAnchor),
            
            mapView.topAnchor.constraint(equalTo: findLocationButton.bottomAnchor, constant: 10),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
            ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .skyBlue4
        
        setupNavigationManu()
        setupUI()
        locationTextField.delegate = self
    }
    
    //MARK:- TextField Delegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}

