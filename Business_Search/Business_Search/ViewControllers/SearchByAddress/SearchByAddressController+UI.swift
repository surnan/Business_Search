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
//        myTextView.delegate = self
        myTextField.delegate = self
        
        
        //myTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
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
        
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        myTextField.leftView = paddingView
        myTextField.leftViewMode = .always
        
        
        view.backgroundColor = .lightBlue
        navigationItem.title = "Search by Address"
        setRightBarButton(state: .disabled)
        
        
        
        let safe = view.safeAreaLayoutGuide
        let redView = viewObject.redView
        
        [myButton, myTextField, locationImageView, mapView, redView].forEach{view.addSubview($0)}

        NSLayoutConstraint.activate([
            locationImageView.topAnchor.constraint(equalTo: safe.topAnchor, constant: 15),
            locationImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            myTextField.topAnchor.constraint(equalTo: locationImageView.bottomAnchor, constant: 15),
            myTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            myTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75),
            myTextField.heightAnchor.constraint(equalToConstant: 30),
            
            
            myButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            myButton.topAnchor.constraint(equalTo: myTextField.bottomAnchor, constant: 15),
            
            
            
            mapView.topAnchor.constraint(equalTo: myButton.bottomAnchor, constant: 15),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            redView.topAnchor.constraint(equalTo: mapView.bottomAnchor),
            redView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            redView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            redView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
    }
}
