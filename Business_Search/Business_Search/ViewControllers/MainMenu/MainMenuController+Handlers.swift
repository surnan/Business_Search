//
//  MainMenuController+Handlers.swift
//  Business_Search
//
//  Created by admin on 7/26/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

extension MainMenuController {
    func pushController(){
        guard let coordinator = coordinator else {print("coordinator is NIL");return}
        mainView.activityView.stopAnimating()
        if coordinateFound {return}
        coordinateFound = true
        switch controllerIndex {
        case 0: coordinator.loadSearchTable(location: userLocation)
        case 1: coordinator.loadSearchByMap(location: userLocation)
        case 2: coordinator.loadSearchByAddress(location: userLocation)
        default:    break
        }
    }
    
    @objc func handleButtons(_ sender: UIButton){
        determineMyCurrentLocation()
        controllerIndex = sender.tag
        mainView.activityView.startAnimating()
    }
    
    @objc func handleSettings(){
        addDarkScreenBlur()
        coordinator?.loadSettings(delegate: self, max: nil)
    }
}
