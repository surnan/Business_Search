//
//  SettingsController+Handlers.swift
//  Business_Search
//
//  Created by admin on 7/28/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

extension SettingsController{
    func addHandlers(){
        viewObject.distanceSlider.addTarget(self, action: #selector(handleSliderValueChange(_:forEvent:)), for: .valueChanged)
        viewObject.saveButton.addTarget(self, action: #selector(handleSaveButton), for: .touchUpInside)
        viewObject.cancelButton.addTarget(self, action: #selector(handlecancelButton), for: .touchUpInside)
        viewObject.defaultsButton.addTarget(self, action: #selector(handleDefaultsButton), for: .touchUpInside)
    }
    
    @objc func handleDefaultsButton(){
        viewObject.myTextView.text = "Hi.  This is a link to a business that I am looking at: "
        UserDefaults.standard.set(viewObject.myTextView.text, forKey: AppConstants.greetingMessage.rawValue)
        fetchLocation.deleteAllLocations()
        self.viewObject.deleteAllLabel.isHidden = false
    }
    
    @objc func handleSliderValueChange(_ sender: UISlider, forEvent event: UIEvent){
        newRadiusValue = Int(sender.value)
        viewObject.sliderValueLabel.text = "\(Int(sender.value))"
    }
    
    @objc func handlecancelButton(){
        dismissController?()
    }
    
    @objc func handleSaveButton(){
        if let newRadius = newRadiusValue {
            radius = newRadius
            fetchLocation.deleteAllLocations()
            UserDefaults.standard.set(radius, forKey: AppConstants.radius.rawValue)
        }
        UserDefaults.standard.set(viewObject.myTextView.text, forKey: AppConstants.greetingMessage.rawValue)
        dismissController?()
    }
}
