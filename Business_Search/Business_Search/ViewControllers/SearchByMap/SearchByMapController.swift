//
//  OverThereLocation.swift
//  Business_Search
//
//  Created by admin on 5/5/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class SearchByMapController: UIViewController, MKMapViewDelegate{
    var coordinator: SearchTableType?
    var viewObject              : SearchByMapView!
    var viewModel               : SearchByMapViewModel!
    lazy var pinImageView       = viewObject.pinImageView
    lazy var mapView            = viewObject.mapView
    var locationToForward       = CLLocation()                //Pushing into newController()

    
    //MARK:- UI
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        mapView.delegate = self
        setupUI()
    }
   

    //MARK:- Map Delegate Function
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        locationToForward = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
    }
}
