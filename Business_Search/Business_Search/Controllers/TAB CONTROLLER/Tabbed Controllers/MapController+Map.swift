//
//  MapController+Map.swift
//  Business_Search
//
//  Created by admin on 6/30/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import MapKit

extension MapController {
    //First tap = didSelect & Second tap = calloutAccessoryTapped
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        //First tap = didSelect
        let selectedAnnotation = view.annotation as? BusinessPointAnnotation
        currentBusinessAnnotation = selectedAnnotation?.business
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        //Second tap = calloutAccessoryTapped
        //Only triggers if "viewFor annotation:" enables accessoryView
        let newVC = BusinessDetailsController()
        newVC.business = currentBusinessAnnotation
        navigationController?.pushViewController(newVC, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let view = mapView.dequeueReusableAnnotationView(withIdentifier: mapViewReuseID, for: annotation)
        if let _ = annotation as? MKClusterAnnotation, let markerAnnotationView = view as? MKMarkerAnnotationView {
            markerAnnotationView.canShowCallout = true
            return markerAnnotationView
        }
        
        if let markerAnnotationView = view as? MKMarkerAnnotationView {
            markerAnnotationView.canShowCallout = true
            //Otherwise icon has default look and behavior when tapped
            let rightButton = UIButton(type: .infoLight)
            markerAnnotationView.rightCalloutAccessoryView = rightButton
            return markerAnnotationView
        }
        
        print("viewFor annotation:\n Annotation Errors")
        return nil
    }
}
