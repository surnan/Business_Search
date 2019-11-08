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
        view.backgroundColor = .white
        navigationItem.title = "Search by Map"
        
        [myTextField, myButton].forEach{addressBarStack.addArrangedSubview($0)}

        navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(handleRightBarButton))]
        let redView = viewObject.redView
        
        [pinImageView, redView, showHideAddressBarButton, addressBarStack, mapView].forEach{view.addSubview($0)}
        let safe = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            showHideAddressBarButton.topAnchor.constraint(equalTo: safe.topAnchor),
            showHideAddressBarButton.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            addressBarStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addressBarStack.topAnchor.constraint(equalTo: showHideAddressBarButton.bottomAnchor, constant: 10),
            myTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75),
            myTextField.heightAnchor.constraint(equalTo: showHideAddressBarButton.heightAnchor),
    
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
        
        setupUI2()
        toggleLocateAddressButton(show: hideAddressBar)
    }
}
