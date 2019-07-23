//
//  SearchByAddressController+UI.swift
//  Business_Search
//
//  Created by admin on 7/22/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit


extension SearchByAddressController{
    func setupUI(){
        
        
        
        
        let stackView: UIStackView = {
            let stack = UIStackView()
            stack.axis = .vertical
            stack.alignment = .center
            stack.distribution = .fill
            stack.spacing = 15
            stack.translatesAutoresizingMaskIntoConstraints = false
            return stack
        }()
        
        [locationTextField, findLocationButton].forEach{
            $0.heightAnchor.constraint(equalToConstant: customUIHeightSize).isActive = true
            stackView.addArrangedSubview($0)
        }
        
        
        [stackView, locationImageView, mapView].forEach{view.addSubview($0)}
        NSLayoutConstraint.activate([
            locationImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            locationImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: locationImageView.bottomAnchor, constant: 10),
            
            locationTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            findLocationButton.widthAnchor.constraint(equalTo: locationTextField.widthAnchor),
            
            mapView.topAnchor.constraint(equalTo: findLocationButton.bottomAnchor, constant: 10),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
            ])
    }
}
