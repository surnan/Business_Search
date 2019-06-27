//
//  ShowBusinessMapAndDirectionsController+Extension.swift
//  Business_Search
//
//  Created by admin on 6/26/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

extension ShowBusinessMapAndDirectionsController {
    //Move map center to current GPS coordinate
    func centerViewOnUserLocation(){
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: location,
                                            latitudinalMeters: regionInMeters,
                                            longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }

    //MARK:- connecting destination & source
    func getDirections(){
        guard let location = locationManager.location?.coordinate else {
            //TODO: Inform user we don't have their current location
            return
        }
        let request = createDirectionsRequest(from: location)
        let directions = MKDirections(request: request)
        resetMapView(withNew: directions)
        directions.calculate { [unowned self](response, error) in
            guard let response = response else { return }   //TODO: Show response not availabe in an alert
            for route in response.routes {                  //an array of routes (below 'AlternateRoutes = true').
                let steps = route.steps                     //Direction each phase (turn right, go straight 5 miles, etc)
                self._steps = steps                         //Pushing to New View Controller
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)//Fit whole map-route onto screen
            }
        }
    }
    
    func createDirectionsRequest(from coordinate: CLLocationCoordinate2D)-> MKDirections.Request {
        //let destinationCoordinate       = getCenterLocation(for: mapView).coordinate
        let temp = CLLocationCoordinate2D(latitude: currentBusiness.latitude, longitude: currentBusiness.longitude)
        let destinationCoordinate       = temp
        let startingLocation            = MKPlacemark(coordinate: coordinate)
        let destination                 = MKPlacemark(coordinate: destinationCoordinate)
        let request                     = MKDirections.Request()
        request.source                  = MKMapItem(placemark: startingLocation)
        request.destination             = MKMapItem(placemark: destination)
        request.transportType           = transport         //Injected from directionSegmentControl
        request.requestsAlternateRoutes = false             //Don't want to show alternate routes without
                                                            //giving user opportunity to change routes to update Routes.
        return request
    }
    
    func resetMapView(withNew directions: MKDirections){
        mapView.removeOverlays(mapView.overlays)
        directionsArray.append(directions)
        let _ = directionsArray.map {$0.cancel()}
        directionsArray.removeAll()
    }
    
    func getCenterLocation(for mapView: MKMapView)-> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        return CLLocation(latitude: latitude, longitude: longitude)
    }
}
