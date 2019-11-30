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
        
        defaultButton.addTarget(self, action: #selector(handleResetToDefaultsButton), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(handleSaveButton), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(handleCancelButton), for: .touchUpInside)
        distanceSlider.addTarget(self, action: #selector(handleSliderValueChange(_:forEvent:)), for: .valueChanged)
        
        
        
        allDollarButtons.forEach{
            $0.addTarget(self, action: #selector(handleDollarButtons(_:)), for: .touchDown)
        }
    }
    
    @objc func handleSliderValueChange(_ sender: UISlider, forEvent event: UIEvent){
        let temp = sender.value.rounded(digits: 1)
        viewObject.sliderValueLabel.text = "\(temp)"
    }
    
    @objc func handleDollarButtons(_ sender: SelectedButton){sender.isSelected = !sender.isSelected}
    @objc func handleCancelButton(){dismissController?()}
    
    @objc func handleSaveButton(){
        UserAppliedFilter.shared.save(dollarOne: dollarOneButton.isSelected,
                                      dollarTwo: dollarTwoButton.isSelected,
                                      dollarThree: dollarThreeButton.isSelected,
                                      dollarFour: dollarFourButton.isSelected,
                                      noPrices: noPriceSwitch.isOn,
                                      minimumRating: sliderValueLabel.text ?? "0.0",
                                      favoritesAtTop: favoriteAtTopSwitch.isOn)
        saveDismissController?()
        
        
        let tempFilterData = AppliedFilter(dollar1: dollarOneButton.isSelected,
                                           dollar2: dollarTwoButton.isSelected,
                                           dollar3: dollarThreeButton.isSelected,
                                           dollar4: dollarFourButton.isSelected,
                                           priceExists: noPriceSwitch.isOn,
                                           favoritesAtTop: favoriteAtTopSwitch.isOn,
                                           minimumRating: sliderValueLabel.text ?? "0.0")
        
        UserAppliedFilter.shared.saveFilterStruct(aFilter: tempFilterData)
    }
    
    @objc func handleResetToDefaultsButton(){
        [viewObject.noPriceSwitch].forEach{$0.isOn = true}
        [viewObject.favoriteAtTopSwitch].forEach{$0.isOn = false}
 
        viewObject.distanceSlider.value = 1.0
        viewObject.sliderValueLabel.text = "1.0"
        allDollarButtons.forEach{
            $0.isSelected = true
            $0.backgroundColor = .white
        }
        
        let tempFilterData = AppliedFilter(dollar1: dollarOneButton.isSelected,
                                           dollar2: dollarTwoButton.isSelected,
                                           dollar3: dollarThreeButton.isSelected,
                                           dollar4: dollarFourButton.isSelected,
                                           priceExists: noPriceSwitch.isOn,
                                           favoritesAtTop: favoriteAtTopSwitch.isOn,
                                           minimumRating: sliderValueLabel.text ?? "0.0")
        
        UserAppliedFilter.shared.saveFilterStruct(aFilter: tempFilterData)
        isFilteredLabel.isHidden = !UserAppliedFilter.shared.isFilterOn
    }
}
