//
//  MainMenuController+Handlers.swift
//  Business_Search
//
//  Created by admin on 7/26/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

extension MainMenuController {
    func addHandlers(){
        [mainView.nearMeSearchButton, mainView.searchByMapButton, mainView.searchByAddressButton].forEach{
            $0.addTarget(self, action: #selector(handleButtons(_:)), for: .touchUpInside)
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
