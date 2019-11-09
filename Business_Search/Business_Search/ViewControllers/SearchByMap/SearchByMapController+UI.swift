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
        anchorMap_SafeAreaTop = mapView.topAnchor.constraint(equalTo: showHideButtonInput.bottomAnchor)
    }
    
    
    func setupUI(){
        navigationItem.title = "Specify Location"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(handleRightBarButton))
        
        [myTextField, locateAddressButton].forEach{addressBarStack.addArrangedSubview($0)}
        [belowSafeView, showHideButtonInput, addressBarStack, mapView, pinImageView].forEach{view.addSubview($0)}
        
        let safe = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            showHideButtonInput.topAnchor.constraint(equalTo: safe.topAnchor),
            showHideButtonInput.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            
            addressBarStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addressBarStack.topAnchor.constraint(equalTo: showHideButtonInput.bottomAnchor, constant: 10),
            myTextField.heightAnchor.constraint(equalTo: showHideButtonInput.heightAnchor),
            myTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75),
            locateAddressButton.widthAnchor.constraint(equalTo: myTextField.widthAnchor, multiplier: 0.6),
            
            
    
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
