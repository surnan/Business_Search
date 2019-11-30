//
//  SettingsController+Handlers.swift
//  Business_Search
//
//  Created by admin on 7/28/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData

extension SettingsController{
    func addHandlers(){
        viewObject.distanceSlider.addTarget(self, action: #selector(handleSliderValueChange(_:forEvent:)), for: .valueChanged)
        viewObject.saveButton.addTarget(self, action: #selector(handleSaveButton), for: .touchUpInside)
        viewObject.cancelButton.addTarget(self, action: #selector(handlecancelButton), for: .touchUpInside)
        viewObject.defaultsButton.addTarget(self, action: #selector(handleDefaultsButton), for: .touchUpInside)
        viewObject.loadFilterButton.addTarget(self, action: #selector(handleLoadFilterButton), for: .touchUpInside)
        
        
        
        
        
        
        
        
        
    }
    
    @objc private func handleSliderValueChange(_ sender: UISlider, forEvent event: UIEvent){
        newRadiusValue = Int(sender.value)
        viewObject.sliderValueLabel.text = "\(Int(sender.value))"
    }
    
    @objc private func handlecancelButton(){
        dismissController?()
    }
    
    @objc func handleLoadFilterButton(){
        dismissCleanly?()
    }
    
    @objc private func handleSaveButton(){
        if let newRadius = newRadiusValue {
            radius = newRadius
            locationsViewModel.deleteAllLocations()
            UserDefaults.standard.set(radius, forKey: AppConstants.radius.rawValue)
        }
        UserDefaults.standard.set(viewObject.myTextView.text, forKey: AppConstants.greetingMessage.rawValue)
        dismissController?()
    }
    
    private func deleteAllFavorites(){
        favoritesViewModel.deleteAllFavorites()
        businessViewModel.removeAllFavorites()
    }
    
    @objc private func handleDefaultsButton(){
        viewObject.resetDefaults()
        self.viewObject.deleteAllLabel.isHidden = false
        newRadiusValue = defaultRadius
        
        if let newRadius = newRadiusValue {
            radius = newRadius
            UserDefaults.standard.set(radius, forKey: AppConstants.radius.rawValue)
        }
        UserDefaults.standard.set(viewObject.myTextView.text, forKey: AppConstants.greetingMessage.rawValue)
        locationsViewModel.deleteAllLocations()
        deleteAllFavorites()
    }
}
