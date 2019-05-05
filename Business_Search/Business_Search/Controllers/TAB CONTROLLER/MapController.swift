//
//  MapController.swift
//  Business_Search
//
//  Created by admin on 5/4/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import MapKit


class MapController: UIViewController, MKMapViewDelegate {
    
    var annotations = [MKPointAnnotation]()
    var mapView = MKMapView()
    var businesses = [Business]()   //injected
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        view.backgroundColor = UIColor.black
        [mapView].forEach{view.addSubview($0)}
        mapView.fillSuperview()
        setupMap()
    }
    
    func setupMap(){
        convertLocationsToAnnotations()
        self.mapView.addAnnotations(annotations)  //There's a singular & plural for 'addAnnotation'.  OMG
    }

    
//    private func convertLocationsToAnnotations2(){
//        for dictionary in locations {
//            let latitude = CLLocationDegrees(dictionary[locationsIndex.latitude.rawValue] as! Double)
//            let longitude = CLLocationDegrees(dictionary[locationsIndex.longitude.rawValue] as! Double)
//            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//
//            let firstName = dictionary[locationsIndex.firstName.rawValue] as! String
//            let lastName = dictionary[locationsIndex.lastName.rawValue] as! String
//            let mediaURL = dictionary[locationsIndex.mediaURL.rawValue] as! String
//
//            let tempAnnotation = MKPointAnnotation()
//            tempAnnotation.coordinate = coordinate
//            tempAnnotation.title = "\(firstName) \(lastName)"
//            tempAnnotation.subtitle = mediaURL
//            annotations.append(tempAnnotation)
//        }
//    }
    
    private func convertLocationsToAnnotations(){
        for business in businesses {
            let latitude = CLLocationDegrees(business.latitude)
            let longitude = CLLocationDegrees(business.longitude)
            
            let tempAnnotation = MKPointAnnotation()
            tempAnnotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            tempAnnotation.title = business.name ?? ""
            annotations.append(tempAnnotation)
        }
    }
}
