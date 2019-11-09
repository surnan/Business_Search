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
        showHideButtonInput.addTarget(self, action: #selector(handleShowHideAddressBarButton(_:)), for: .touchDown)
        locateAddressButton.addTarget(self, action: #selector(handleLocateAddressButton), for: .touchDown)
    }
    
    @objc func handleRightBarButton(){
        coordinator?.loadSearchTable(location: locationToForward)
    }

    @objc func handleLocateAddressButton(){
        geoCoder.geocodeAddressString(myTextField.text ?? "") { [weak self] (clplacement, error) in
            guard let placemarks = clplacement, let location = placemarks.first?.location else {
                self?.showAlertController(title: "Input Error", message: "Unable to find location on map")
                return
            }
            self?.locationToForward = location
            DispatchQueue.main.async {[weak self] in
                guard let self = self else {return}
                let newCoordinates = self.locationToForward.coordinate
                self.mapView.setCenter(newCoordinates, animated: true)
            }
        }
    }
    
    @objc func handleShowHideAddressBarButton(_ sender: UIButton){
        hideAddressBar = !hideAddressBar
        if sender.title(for: .normal) == hideAddressBarTxt {
            sender.backgroundColor = showAddressColor
            sender.setTitle(showAddressBarTxt, for: .normal)
            toggleLocateAddressButton(show: hideAddressBar)
            return
        }
        sender.backgroundColor = hideAddressColor
        sender.setTitle(hideAddressBarTxt, for: .normal)
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
