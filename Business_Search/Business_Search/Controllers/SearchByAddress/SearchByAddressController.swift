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
    let geoCoder = CLGeocoder()
    var possibleInsertLocationCoordinate: CLLocation!   //Injected from MenuController()
    var locationToForward = CLLocation()                //Pushing into newController()
    var dataController: DataController!                 //Injected from MenuController()
    var coordinator: BarButtonToOpeningType?

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
    
    @objc func handleNext(){
        coordinator?.handleNext(dataController: dataController, location: locationToForward)
    }
    
    
    func setupNavigationManu(){
        navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(handleNext))]
        //        navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(handleRight)),
        //                                              UIBarButtonItem(title: "⏸", style: .done, target: self, action: #selector(handlePause))]
    }
    

    @objc func handlePause() {
        print(" mapView.centerCoordinate = \(mapView.centerCoordinate)")
    }
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
