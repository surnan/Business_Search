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
import GoogleMaps


class GoToMapController: UIViewController, CLLocationManagerDelegate {
    
    var business: Business!     //Injected
    lazy var googleMapView: GMSMapView = {
        let view = GMSMapView()
        view.delegate = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        let camera = GMSCameraPosition.camera(withLatitude: business.latitude, longitude: business.longitude, zoom: 17.0)
        googleMapView.camera = camera
        showMarker(position: googleMapView.camera.target)
        
        view.addSubview(googleMapView)
        googleMapView.fillSafeSuperView()
    }
    
    
    func showMarker(position: CLLocationCoordinate2D){
        let marker = GMSMarker()
        marker.position = position
        marker.title = "NYC"
        marker.snippet = "My Snippet"
        marker.map = googleMapView
    }
}

extension GoToMapController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        print("Clicked on marker")
    }
}
