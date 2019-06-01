////
////  GoToMap.swift
////  Business_Search
////
////  Created by admin on 5/26/19.
////  Copyright © 2019 admin. All rights reserved.
////
//
//import UIKit
//import MapKit
//import CoreLocation
//import GoogleMaps
//
//
//class GoToMapController: UIViewController, CLLocationManagerDelegate {
//    
//    var business: Business!     //Injected
//    lazy var googleMapView: GMSMapView = {
//        let view = GMSMapView()
//        let mapInsets = UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0)
//        view.padding = mapInsets
//        view.mapType = .normal
//        view.delegate = self
//        view.isMyLocationEnabled = true
//        return view
//    }()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .lightRed
//        let camera = GMSCameraPosition.camera(withLatitude: business.latitude, longitude: business.longitude, zoom: 16.0)
//        googleMapView.camera = camera
//        showMarker(position: googleMapView.camera.target)
//        view.addSubview(googleMapView)
//        googleMapView.fillSafeSuperView()
//    }
//    
//    func showMarker(position: CLLocationCoordinate2D){
//        let marker = GMSMarker()
//        marker.position = position
//        marker.title = "NYC"
//        marker.snippet = "My Snippet"
//        marker.map = googleMapView
//        //marker.icon = GMSMarker.markerImage(with: .lightRed)
//        marker.icon = #imageLiteral(resourceName: "pin").withRenderingMode(.alwaysOriginal)
//    }
//}
//
//extension GoToMapController: GMSMapViewDelegate {
//    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
//        print("Clicked on marker")
//    }
//}
