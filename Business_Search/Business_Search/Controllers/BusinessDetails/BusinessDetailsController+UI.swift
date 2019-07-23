//
//  BusinessDetailsController+UI.swift
//  Business_Search
//
//  Created by admin on 7/1/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData
import MapKit
import CoreLocation

extension BusinessDetailsController {
    
    func setupMapView(){
        let viewRegion = MKCoordinateRegion(center: model.firstAnnotation.coordinate,
                                            latitudinalMeters: regionMetersForMap,
                                            longitudinalMeters: regionMetersForMap)
        model.mapView.setRegion(viewRegion, animated: false)
        model.mapView.addAnnotation(model.firstAnnotation)
        model.mapView.delegate = self
    }
    
    func setupUI(){
        let safe                = view.safeAreaLayoutGuide
        let buttonStack         = model.getButtonStack()
        let fullStackNoButtons  = model.getFullStack()
        
        [model.mapView, model.nameLabel, fullStackNoButtons, buttonStack].forEach{view.addSubview($0)}
        model.mapView.anchor(top: safe.topAnchor, leading: safe.leadingAnchor, trailing: safe.trailingAnchor,
                             padding: .init(top: 3, left: 3, bottom: 0, right: 3))
        
        view.backgroundColor = UIColor.white
        NSLayoutConstraint.activate([
            model.mapView.heightAnchor.constraint(equalTo: safe.heightAnchor, multiplier: 0.25),
            model.nameLabel.topAnchor.constraint(equalTo: model.mapView.bottomAnchor, constant: 10),
            model.nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            model.nameLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.80),
            fullStackNoButtons.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            fullStackNoButtons.topAnchor.constraint(equalTo: model.nameLabel.bottomAnchor, constant: 15),
            buttonStack.topAnchor.constraint(equalTo: fullStackNoButtons.bottomAnchor, constant: 20),
            buttonStack.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.66),
            buttonStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ])
    }
}
