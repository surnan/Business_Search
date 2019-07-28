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
        if previousCoordinate   == nil {
            previousCoordinate  = userLocation
        } else if let previous  = previousCoordinate, userLocation.distance(from: previous) < 10 {
            userLocation        = previous  //Prevents creating new Location entity too close to one in CoreData
        }
        pushController()
    }
    
    private func pushController(){
        guard let coordinator = coordinator else {print("coordinator is NIL");return}
        mainView.activityView.stopAnimating()
        if coordinateFound {return}
        coordinateFound = true
        switch controllerIndex {
        case 0: coordinator.loadSearchTable(location: userLocation)
        case 1: coordinator.loadSearchByMap(location: userLocation)
        case 2: coordinator.loadSearchByAddress(location: userLocation)
        default:    break
        }
    }
}
