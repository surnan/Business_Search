//
//  MapController.swift
//  Business_Search
//
//  Created by admin on 5/4/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import MapKit

class BusinessPointAnnotation: MKPointAnnotation {
    var business: Business!
    init(business: Business) {
        self.business = business
    }
}

class GroupMapController: UIViewController, MKMapViewDelegate {
    var currentBusinessAnnotation: Business?        //tapped Annotation
    var businesses              = [Business]()      //injected
    let mapViewReuseID          = "mapViewReuseID"
 
    var coordinator: (BusinessDetailsType & DismissType)?
    

    lazy var scaleView          = GenericScaleView(mapView: mapView)
    lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.delegate = self
        mapView.register(BusinessAnnotationView.self, forAnnotationViewWithReuseIdentifier: mapViewReuseID)
        return mapView
    }()
    
    
    //MARK:- Functions START
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true   //hides the searchController bar
        setupMap()      //ViewWillAppear: annotations stack on top each when popping back
        setupNavigationBar()
    }
    
    func setupNavigationBar(){
        navigationController?.isNavigationBarHidden = false
        navigationItem.title = "categoryName2"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Dismiss 2", style: .plain, target: self,
                                                           action: #selector(handleDismiss))
    }
    
    @objc func handleDismiss(){
        coordinator?.handleDismiss()
    }
    
    
    func setupMap(){
        let allAnnotations = convertLocationsToAnnotations()
        mapView.addAnnotations(allAnnotations)
        mapView.showAnnotations(allAnnotations, animated: true)    //animated: No Effect here
        let safe = view.safeAreaLayoutGuide
        [mapView, scaleView].forEach{view.addSubview($0)}
        mapView.fillSafeSuperView()
        scaleView.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -10).isActive = true
        scaleView.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -10).isActive = true
    }
    
    private func convertLocationsToAnnotations()->[MKPointAnnotation]{
        var annotations = [MKPointAnnotation]()
        for business in businesses {
            let latitude = CLLocationDegrees(business.latitude)
            let longitude = CLLocationDegrees(business.longitude)
            let tempAnnotation = BusinessPointAnnotation(business: business)
            tempAnnotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            tempAnnotation.title = business.name ?? ""
            if let price = business.price {
                tempAnnotation.subtitle = "Price: \(price)"
            }
            tempAnnotation.business = business
            annotations.append(tempAnnotation)
        }
        return annotations
    }
}



