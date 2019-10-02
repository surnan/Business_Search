//
//  MainMenuController+Handlers.swift
//  Business_Search
//
//  Created by admin on 7/26/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import MapKit

extension MainMenuController {
    func addHandlers(){
        [mainView.nearMeSearchButton, mainView.searchByMapButton, mainView.searchByAddressButton].forEach{
            $0.addTarget(self, action: #selector(handleButtons(_:)), for: .touchUpInside)
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showFinishNetworkRequest()
    }
    
    @objc func handleFilter(){
        addDarkScreenBlur()
        coordinator?.loadFilter(unblurProtocol: self)
    }
    
    @objc func handleBlank(){
    }
    
    @objc func handleButtons(_ sender: UIButton){
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "", style: .done, target: self, action: #selector(handleBlank))
        determineMyCurrentLocation()
        controllerIndex = sender.tag
    }
    
    @objc func handleSettings(){
        addDarkScreenBlur()
        coordinator?.loadSettings(delegate: self, max: nil)
    }
    
    private func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate        = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            showNONPassThroughNetworkActivityView()
            locationManager.startUpdatingLocation()
        } else {
            
        }
    }
}
