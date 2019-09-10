//
//  SearchByAddressController+UI.swift
//  Business_Search
//
//  Created by admin on 7/28/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

extension SearchByAddressController {
    func setupUI(){
        view.backgroundColor = #colorLiteral(red: 0.93198663, green: 0.9809250236, blue: 0.9644866586, alpha: 1)
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(handleRightBarButton))]
        let safe = view.safeAreaLayoutGuide
        let stackView = viewObject.getStackView()
        let redView = viewObject.redView
        [stackView, locationImageView, mapView, redView].forEach{view.addSubview($0)}
        locationImageView.anchor(top: safe.topAnchor, padding: .init(top: 10, left: 0, bottom: 0, right: 0), centerX: true)
        stackView.anchor(top: locationImageView.bottomAnchor, padding: .init(top: 10, left: 0, bottom: 0, right: 0), centerX: true)
        viewObject.locationTextField.anchor(x: view.widthAnchor, xMultiply: 0.7)
        viewObject.findLocationButton.anchor(x: view.widthAnchor, xMultiply: 0.7)
        mapView.anchor(top: stackView.bottomAnchor, leading: safe.leadingAnchor, trailing: safe.trailingAnchor, bottom: safe.bottomAnchor,
                       padding: .init(top: 10, left: 0, bottom: 0, right: 0))
        
        NSLayoutConstraint.activate([
            redView.topAnchor.constraint(equalTo: mapView.bottomAnchor),
            redView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            redView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            redView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
    }
}
