//
//  SearchByMapController+UI.swift
//  Business_Search
//
//  Created by admin on 7/28/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

extension SearchByMapController {

    func setupUI(){
        navigationItem.title = "Search by Map"

        navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(handleRightBarButton))]
        let redView = viewObject.redView
        
        [mapView, pinImageView, redView, showHideAddressBarButton].forEach{view.addSubview($0)}
        //mapView.fillSafeSuperView()
        let safe = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            showHideAddressBarButton.topAnchor.constraint(equalTo: safe.topAnchor),
            showHideAddressBarButton.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            mapView.topAnchor.constraint(equalTo: showHideAddressBarButton.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            
            pinImageView.centerXAnchor.constraint(equalTo: mapView.centerXAnchor),
            pinImageView.centerYAnchor.constraint(equalTo: mapView.centerYAnchor),
            redView.topAnchor.constraint(equalTo: mapView.bottomAnchor),
            redView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            redView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            redView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
    }
}
