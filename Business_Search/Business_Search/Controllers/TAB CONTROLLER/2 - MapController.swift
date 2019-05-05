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
        zoomMapaFitAnnotations()
    }
    
    
    func zoomMapaFitAnnotations() {
        var zoomRect = MKMapRect.null
        for annotation in mapView.annotations {
            let annotationPoint = MKMapPoint(annotation.coordinate)
            let pointRect = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0, height: 0)
            zoomRect = zoomRect.union(pointRect)
        }
        mapView.setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50), animated: true)
    }
    
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
