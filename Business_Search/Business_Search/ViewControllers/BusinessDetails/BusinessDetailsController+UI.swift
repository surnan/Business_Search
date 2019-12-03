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
    
    override func viewDidLoad() {
        setupUI()
        addHandlers()
        setupLocationManager()
    }
    
    func setupLocationManager(){
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }

    func setupUI(){
        view.backgroundColor = UIColor.white
        let safe        = view.safeAreaLayoutGuide

        
        [mapView, nameLabel, infoStack, buttonStack, redView].forEach{view.addSubview($0)}
        
        mapView.anchor(top: safe.topAnchor, leading: safe.leadingAnchor, trailing: safe.trailingAnchor,
                                padding: .init(top: 3, left: 3, bottom: 0, right: 3),
                                y: safe.heightAnchor, yMultiply: 0.40)
        
        nameLabel.anchor(top: mapView.bottomAnchor,
                                  padding: .init(top: 15, left: 0, bottom: 0, right: 0),
                                  centerX: true, x: view.widthAnchor, xMultiply: 0.8)
        
        infoStack.anchor(top: nameLabel.bottomAnchor, padding: .init(top: 15, left: 0, bottom: 0, right: 0), centerX: true)
        buttonStack.anchor(top: infoStack.bottomAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 0),
                           centerX: true, x: view.widthAnchor, xMultiply: 0.66)
        
        
        NSLayoutConstraint.activate([
            redView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            redView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            redView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            redView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
    }
}

extension UIViewController {
    func clearBackButton(){
        //removed "BACK" from the left bar button title after navigation push.
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
