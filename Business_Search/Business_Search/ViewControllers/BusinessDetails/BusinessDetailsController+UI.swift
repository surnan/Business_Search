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
        let viewRegion = MKCoordinateRegion(center: mainView.firstAnnotation.coordinate,
                                            latitudinalMeters: regionMetersForMap,
                                            longitudinalMeters: regionMetersForMap)
        mainView.mapView.setRegion(viewRegion, animated: false)
        mainView.mapView.addAnnotation(mainView.firstAnnotation)
        mainView.mapView.delegate = self
    }
    
    func setupUI(){
        view.backgroundColor = UIColor.white
        let safe                = view.safeAreaLayoutGuide
        let buttonStack         = mainView.getButtonStack()
        let fullStackNoButtons  = mainView.getFullStack()
        
        [mainView.mapView, mainView.nameLabel, fullStackNoButtons, buttonStack].forEach{view.addSubview($0)}
        mainView.mapView.anchor(top: safe.topAnchor, leading: safe.leadingAnchor, trailing: safe.trailingAnchor,
                             padding: .init(top: 3, left: 3, bottom: 0, right: 3))
        [mainView.nameLabel, fullStackNoButtons, buttonStack].forEach{$0.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true}
        
        NSLayoutConstraint.activate([
            mainView.mapView.heightAnchor.constraint(equalTo: safe.heightAnchor, multiplier: 0.25),
            mainView.nameLabel.topAnchor.constraint(equalTo: mainView.mapView.bottomAnchor, constant: 10),
            mainView.nameLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.80),
            fullStackNoButtons.topAnchor.constraint(equalTo: mainView.nameLabel.bottomAnchor, constant: 15),
            buttonStack.topAnchor.constraint(equalTo: fullStackNoButtons.bottomAnchor, constant: 20),
            buttonStack.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.66),
            ])
    }
}
