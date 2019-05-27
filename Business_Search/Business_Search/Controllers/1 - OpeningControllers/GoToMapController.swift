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

class GoToMapController: UIViewController, CLLocationManagerDelegate {
    
    var mapView: MKMapView = {
        let mapView = MKMapView()
        return mapView
    }()
    
    var business: Business!
    let locationManager = CLLocationManager()
    let geoCoder = CLGeocoder()
    var directionsArray: [MKDirections] = []
    let regionInMeters: Double = 1000.0
    var previousLocation: CLLocation?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.showsUserLocation = true
        view.addSubview(mapView)
        mapView.fillSafeSuperView()
        addDestination()
    }
    
    
    
    func addDestination(){
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.coordinate = CLLocationCoordinate2D(latitude: business.latitude, longitude: business.longitude)
        mapView.addAnnotation(destinationAnnotation)
        mapView.showAnnotations([destinationAnnotation], animated: true)
    }
    
    
//    func startTrackingUserLocation(){
//        mapView.showsUserLocation = true
//        centerViewOnUserLocation()
//        locationManager.startUpdatingLocation() //triggers "locationManager - didUpdateLocations"
//        previousLocation = getCenterLocation(for: mapView)
//    }
}
