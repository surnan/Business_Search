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
        //viewObject.deleteFavoritesButton.addTarget(self, action: #selector(handleDeleteFavorites), for: .touchUpInside)
    }
    
    @objc func handleDeleteFavorites(){
        favoritesViewModel.deleteAllFavorites()
        businessViewModel.removeAllFavorites()
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
            locationsViewModel.deleteAllLocations()
            UserDefaults.standard.set(radius, forKey: AppConstants.radius.rawValue)
        }
        UserDefaults.standard.set(viewObject.myTextView.text, forKey: AppConstants.greetingMessage.rawValue)
        dismissController?()
    }
    
    func deleteAllFavorites(){
        favoritesViewModel.deleteAllFavorites()
        businessViewModel.removeAllFavorites()
    }
    
    @objc func handleDefaultsButton(){
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
