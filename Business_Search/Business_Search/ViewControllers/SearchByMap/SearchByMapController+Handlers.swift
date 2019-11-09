//
//  SearchByMapController+Handlers.swift
//  Business_Search
//
//  Created by admin on 7/28/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

extension SearchByMapController {
    func addHandlers(){
        showHideButton.addTarget(self, action: #selector(handleShowHideAddressBarButton(_:)), for: .touchDown)
        locateAddressButton.addTarget(self, action: #selector(handleLocateAddressButton), for: .touchDown)
    }
    
    @objc func handleRightBarButton(){
        coordinator?.loadSearchTable(location: locationToForward)
    }
    
    @objc func handleLocateAddressButton(){
        print("")
    }
    
    @objc func handleShowHideAddressBarButton(_ sender: UIButton){
        hideAddressBar = !hideAddressBar
        if sender.title(for: .normal) == "Hide Address Bar" {
            sender.backgroundColor = .darkBlue
            sender.setTitle("Show Address Bar", for: .normal)
            toggleLocateAddressButton(show: hideAddressBar)
            return
        }
        sender.backgroundColor = UIColor.darkGreen
        sender.setTitle("Hide Address Bar", for: .normal)
        toggleLocateAddressButton(show: hideAddressBar)
    }
    
    private func showAddressButton(){
        anchorMap_ShowHideButton?.isActive = false
        anchorMap_SafeAreaTop?.isActive = true
    }
    
    
    private func hideAddressButton(){
        anchorMap_SafeAreaTop?.isActive = false
        anchorMap_ShowHideButton?.isActive = true
    }
    
    func toggleLocateAddressButton(show: Bool){
        show ? showAddressButton() : hideAddressButton()
        UIView.animate(withDuration: 0.15,
                       animations: {self.view.layoutIfNeeded()},
                       completion: nil)
    }
}
