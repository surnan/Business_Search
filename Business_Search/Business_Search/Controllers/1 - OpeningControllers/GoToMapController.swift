//
//  GoToMap.swift
//  Business_Search
//
//  Created by admin on 5/26/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class GoToMapController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var business: Business!     //Injected
    
    //private var scaleView: MKScaleView!
    
    lazy var scaleView: MKScaleView = {
        let scaleView = MKScaleView(mapView: mapView)
        scaleView.legendAlignment = .trailing
        scaleView.scaleVisibility = .visible
        scaleView.translatesAutoresizingMaskIntoConstraints = false
        return scaleView
    }()
    
    lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.delegate = self
        return mapView
    }()
    
    lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        return locationManager
    }()
    
    lazy var directionSegmentControl: UISegmentedControl = {
        let items = ["Walking", "Driving", "Mass-Transit"]
        let segment = UISegmentedControl(items: items)
        segment.selectedSegmentIndex = 0
        segment.backgroundColor = .white
        segment.addTarget(self, action: #selector(handleDirectionSegmentControl(_:)), for: .valueChanged)
        segment.translatesAutoresizingMaskIntoConstraints = false
        return segment
    }()
    
    lazy var compass: MKCompassButton = {
        let compass = MKCompassButton(mapView: mapView)
        compass.compassVisibility = .visible
        compass.translatesAutoresizingMaskIntoConstraints = false
        return compass
    }()
    
    func setupCompass() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: compass)
    }
    
    @objc func handleDirectionSegmentControl(_ sender: UISegmentedControl){
        switch sender.selectedSegmentIndex {
        case 0:
            print("Selected Index 0")
        case 1:
            print("Selected Index 1")
        case 2:
            print("Selected Index 2")
        default:
            print("Illegal Index value")
        }
    }
    
    
    
    
    
    let geoCoder = CLGeocoder()
    var directionsArray: [MKDirections] = []
    let regionInMeters: Double = 1000.0
    var previousLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.showsUserLocation = true
        addDestination()
        [mapView, directionSegmentControl, scaleView].forEach{view.addSubview($0)}
        
        
        NSLayoutConstraint.activate([
            directionSegmentControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            directionSegmentControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scaleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            scaleView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 5)
            ])
        
        
        mapView.fillSafeSuperView()
        setupCompass()
        
        
        
    }
    
    func addDestination(){
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.coordinate = CLLocationCoordinate2D(latitude: business.latitude, longitude: business.longitude)
        mapView.addAnnotation(destinationAnnotation)
        mapView.showAnnotations([destinationAnnotation], animated: true)
    }

    func centerViewOnUserLocation(){
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: location,
                                            latitudinalMeters: regionInMeters,
                                            longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }

}
