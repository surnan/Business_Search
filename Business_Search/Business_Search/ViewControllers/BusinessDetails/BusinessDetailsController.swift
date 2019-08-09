//
//  BusinessController.swift
//  Business_Search
//
//  Created by admin on 5/10/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData
import MapKit
import CoreLocation

class BusinessDetailsController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    let regionMetersForMap      = 400.0
    var currentLocation         : CLLocation?
    var locationManager         = GenericCLLocationManager(desiredAccuracy: kCLLocationAccuracyBest)
    var coordinator             : (OpenInSafariType & OpenAppleMapType & OpenPhoneType)?
    var viewObject              : BusinessDetailsView!
    var viewModel               : BusinessDetailsViewModel!
    

    override func viewDidLoad() {
        setupUI()
        addHandlers()
        setupLocationManager()
    }
    
    func setupLocationManager(){
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
}
