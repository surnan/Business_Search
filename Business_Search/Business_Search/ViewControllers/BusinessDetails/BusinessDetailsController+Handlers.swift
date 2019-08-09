//
//  File.swift
//  Business_Search
//
//  Created by admin on 7/28/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

extension BusinessDetailsController {
    func addHandlers(){
        viewObject.phoneNumberButton.addTarget(self, action: #selector(handlePhoneNumberButton(sender:)), for: .touchUpInside)
        viewObject.visitYelpPageButton.addTarget(self, action: #selector(handleVisitYelpPageButton(_:)), for: .touchUpInside)
        viewObject.directionsButton.addTarget(self, action: #selector(handleMapItButton(_:)), for: .touchUpInside)
    }
    
    @objc func handlePhoneNumberButton(sender: UIButton){
        guard let numberString = sender.titleLabel?.text else {return}
        coordinator?.loadPhoneCallScreen(number: numberString)
    }
    
    @objc func handleVisitYelpPageButton(_ sender: UIButton){
        if let urlStringExists = viewModel.getUrlString, urlStringExists._isValidURL {
            coordinator?.loadSafariBrowser(url: urlStringExists)
        } else {
            coordinator?.loadSafariBrowser(url: "https://www.yelp.com")
        }
    }
    
    @objc func handleMapItButton(_ sender: UIButton){
        guard let currentLocation = locationManager.location?.coordinate else {print("Unable to get current Location"); return}
        coordinator?.loadAppleMap(currentLocation: currentLocation)
    }
}
