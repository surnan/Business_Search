//
//  SearchByAddressController+Handlers.swift
//  Business_Search
//
//  Created by admin on 7/28/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import MapKit

extension SearchByAddressController {
    func addHandlers(){
        findLocationButton.addTarget(self, action: #selector(handleFindButton(_:)), for: .touchUpInside)
    }
    
    @objc func handleRightBarButton(){
        coordinator?.loadSearchTable(location: locationToForward)
    }
    
    @objc func handleFindButton(_ sender: UIButton){
        view.endEditing(true)
        geoCoder.geocodeAddressString(myTextView.text ?? "") { [weak self] (clplacement, error) in
            guard let placemarks = clplacement, let location = placemarks.first?.location else {
                sender.isSelected = false
                self?.showAlertController(title: "Input Error", message: "Unable to find location on map")
                return
            }
            self?.locationToForward = location
            DispatchQueue.main.async {[weak self] in
                guard let self = self else {return}
                let newAnnotation = MKPointAnnotation()
                newAnnotation.coordinate = (self.locationToForward.coordinate)
                let oldAnnotations = self.mapView.annotations
                self.mapView.removeAnnotations(oldAnnotations)
                self.mapView.addAnnotation(newAnnotation)
                self.mapView.setCenter(newAnnotation.coordinate, animated: false)
                let coord = self.mapView.centerCoordinate
                self.locationToForward =  CLLocation(latitude: coord.latitude, longitude: coord.longitude)
            }
        }
    }
}
