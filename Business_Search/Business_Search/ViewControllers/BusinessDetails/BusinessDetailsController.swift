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


//let buttonStack = viewObject.getButtonStack()
//let infoStack   = viewObject.getFullStack()
//let redView = viewObject.redView
//let nameLabel = viewObject.nameLabel
//let mapView = viewObject.mapView


class BusinessDetailsController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    let regionMetersForMap      = 400.0
    var currentLocation         : CLLocation?
    var locationManager         = GenericCLLocationManager(desiredAccuracy: kCLLocationAccuracyBest)
    var coordinator             : (OpenInSafariType & OpenAppleMapType & OpenPhoneType)?


    var viewObject              : BusinessDetailsView! {
        didSet {
            buttonStack = viewObject.getButtonStack()
            infoStack   = viewObject.getFullStack()
            redView     = viewObject.redView
            nameLabel   = viewObject.nameLabel
            mapView     = viewObject.mapView
            navigationItem.title = nameLabel.text ?? ""
        }
    }

    
    
    


    var viewModel               : BusinessDetailsViewModel!
    
    var businessViewModel       : BusinessViewModel!
    var favoriteViewModel       : FavoritesViewModel!
    var currentBusiness         : Business!

    //MARK:- ViewObject VAR
    var buttonStack : UIStackView!
    var infoStack   : UIStackView!
    var redView     : UIView!
    var nameLabel   : UILabel!
    var mapView     : GenericMapView!
    
}
