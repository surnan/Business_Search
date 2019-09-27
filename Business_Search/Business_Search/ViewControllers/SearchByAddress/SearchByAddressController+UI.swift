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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        locationTextField.delegate = self
        myTextView.delegate = self
        
        barButtonState = ButtonState.disabled   //likely don't need this
        
        setupUI()
        addHandlers()
    }
    
    
    
    func setRightBarButton(state: ButtonState){
        let nextAction =  UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(handleRightBarButton))
        let findAction =  UIBarButtonItem(title: "Find", style: .done, target: self, action: #selector(handleFindButton(_:)))

        switch state {
        case .next:
            nextAction.isEnabled = true
            navigationItem.rightBarButtonItem = nextAction
        case .disabled:
            nextAction.isEnabled = false
            navigationItem.rightBarButtonItem = nextAction
        case .find:
            navigationItem.rightBarButtonItem = findAction
        }
    }
    
    
    func setupUI(){
        view.backgroundColor = .lightBlue
        navigationItem.title = "Search by Address"
        setRightBarButton(state: .disabled)
        
        
        
        let safe = view.safeAreaLayoutGuide
        let redView = viewObject.redView
        
        [myTextView, locationImageView, mapView, redView].forEach{view.addSubview($0)}


        NSLayoutConstraint.activate([
            locationImageView.topAnchor.constraint(equalTo: safe.topAnchor, constant: 15),
            locationImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            myTextView.topAnchor.constraint(equalTo: locationImageView.bottomAnchor, constant: 20),
            myTextView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75),
            myTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            myTextView.heightAnchor.constraint(lessThanOrEqualToConstant: textViewMaxHeight),
            
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.topAnchor.constraint(equalTo: myTextView.bottomAnchor, constant: 15),
            mapView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            
            redView.topAnchor.constraint(equalTo: mapView.bottomAnchor),
            redView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            redView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            redView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            
            ])
    }
}










/*
func setupUI(){
    
    navigationItem.title = "Search by Address"
    
    view.backgroundColor = #colorLiteral(red: 0.93198663, green: 0.9809250236, blue: 0.9644866586, alpha: 1)
    
    navigationItem.rightBarButtonItem = updateBarButton()
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
*/
