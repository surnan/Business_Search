//
//  FilterController+Handlers.swift
//  Business_Search
//
//  Created by admin on 7/28/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

extension FilterController {
    func addHandlers(){
        viewObject.defaultButton.addTarget(self, action: #selector(handleResetToDefaultsButton), for: .touchUpInside)
        viewObject.saveButton.addTarget(self, action: #selector(handleSaveButton), for: .touchUpInside)
        viewObject.cancelButton.addTarget(self, action: #selector(handleCancelButton), for: .touchUpInside)
        viewObject.distanceSlider.addTarget(self, action: #selector(handleSliderValueChange(_:forEvent:)), for: .valueChanged)
        allDollarButtons.forEach{
            $0.addTarget(self, action: #selector(handleDollarButtons(_:)), for: .touchDown)
        }
    }
    
    @objc func handleSliderValueChange(_ sender: UISlider, forEvent event: UIEvent){
        let temp = sender.value.rounded(digits: 1)
        viewObject.sliderValueLabel.text = "\(temp)"
    }
    
    @objc func handleDollarButtons(_ sender: CustomButton){sender.isSelected = !sender.isSelected}
    @objc func handleCancelButton(){dismissController?()}
    
    @objc func handleSaveButton(){
        UserAppliedFilter.shared.save(dollarOne: viewObject.dollarOneButton.isSelected,
                                      dollarTwo: viewObject.dollarTwoButton.isSelected,
                                      dollarThree: viewObject.dollarThreeButton.isSelected,
                                      dollarFour: viewObject.dollarFourButton.isSelected,
                                      noPrices: viewObject.noPriceSwitch.isOn,
                                      minimumRating: viewObject.sliderValueLabel.text ?? "0.0",
                                      favoritesAtTop: viewObject.favoriteAtTopSwitch.isOn)
        saveDismissController?()
        
        
        let tempFilterData = AppliedFilter(dollar1: viewObject.dollarOneButton.isSelected,
                                           dollar2: viewObject.dollarTwoButton.isSelected,
                                           dollar3: viewObject.dollarThreeButton.isSelected,
                                           dollar4: viewObject.dollarFourButton.isSelected,
                                           priceExists: viewObject.noPriceSwitch.isOn,
                                           favoritesAtTop: viewObject.favoriteAtTopSwitch.isOn,
                                           minimumRating: viewObject.sliderValueLabel.text ?? "0.0")
        
        UserAppliedFilter.shared.saveFilterStruct(aFilter: tempFilterData)
        print("")
        
    }
    
    @objc func handleResetToDefaultsButton(){
        [viewObject.noPriceSwitch, viewObject.favoriteAtTopSwitch].forEach{$0.isOn = true}
        viewObject.distanceSlider.value = 1.0
        viewObject.sliderValueLabel.text = "1.0"
        allDollarButtons.forEach{
            $0.isSelected = true
            $0.backgroundColor = .white
        }
    }
}


