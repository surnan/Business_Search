//
//  MainMenuController+CLLocation.swift
//  Business_Search
//
//  Created by admin on 6/30/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreLocation

extension MainMenuController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations.last
        locationManager.stopUpdatingLocation()
        if previousCoordinate == nil {
            previousCoordinate = userLocation
        } else if let previous = previousCoordinate, userLocation.distance(from: previous) < 10 {
            //Prevents app from uploading a new Location entity too close to an existing one saved in CoreData
            userLocation = previous
        }
        pushNextController()
    }
    
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
}
