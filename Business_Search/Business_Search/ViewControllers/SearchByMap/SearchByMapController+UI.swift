//
//  SearchByMapController+UI.swift
//  Business_Search
//
//  Created by admin on 7/28/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

extension SearchByMapController {

    private func setupDynamicConstraints(){
        anchorMap_ShowHideButton = mapView.topAnchor.constraint(equalTo: addressBarStack.bottomAnchor, constant: 5)
        anchorMap_SafeAreaTop = mapView.topAnchor.constraint(equalTo: showHideButton.bottomAnchor)
    }
    
    
    func setupUI(){
        view.backgroundColor = .white
        navigationItem.title = "Search by Map"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(handleRightBarButton))
        
        [myTextField, locateAddressButton].forEach{addressBarStack.addArrangedSubview($0)}
        [pinImageView, belowSafeView, showHideButton, addressBarStack, mapView].forEach{view.addSubview($0)}
        
        let safe = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            showHideButton.topAnchor.constraint(equalTo: safe.topAnchor),
            showHideButton.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            addressBarStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addressBarStack.topAnchor.constraint(equalTo: showHideButton.bottomAnchor, constant: 10),
            myTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75),
            myTextField.heightAnchor.constraint(equalTo: showHideButton.heightAnchor),
    
            mapView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            pinImageView.centerXAnchor.constraint(equalTo: mapView.centerXAnchor),
            pinImageView.centerYAnchor.constraint(equalTo: mapView.centerYAnchor),
            belowSafeView.topAnchor.constraint(equalTo: mapView.bottomAnchor),
            belowSafeView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            belowSafeView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            belowSafeView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        
        setupDynamicConstraints()
        toggleLocateAddressButton(show: hideAddressBar)
    }
}
