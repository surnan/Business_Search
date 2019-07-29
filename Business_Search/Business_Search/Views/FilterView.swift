//
//  FilterView.swift
//  Business_Search
//
//  Created by admin on 7/28/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class FilterView {
    var viewModel: FilterViewModel?{
        didSet{
            guard let viewModel = viewModel else {
                print("SettingsView.ViewModel = NIL")
                return
            }
            minimumRatingText = viewModel.getMinimumRatingText
            sliderValue     = viewModel.getSliderValue
            dollarOneButton.isSelected =  viewModel.getDollarOneButtonSelected
            dollarTwoButton.isSelected =  viewModel.getDollarTwoButtonSelected
            dollarThreeButton.isSelected =  viewModel.getDollarThreeButtonSelected
            dollarFourButton.isSelected =  viewModel.getDollarFourButtonSelected
            noPriceSwitch.isOn =   viewModel.getNoPriceSwitchIsOn
            favoriteAtTopSwitch.isOn = viewModel.getFavoritesAtTop
            updateButtonColors()
        }
    }
    
    private var sliderLabel         = GenericLabel(text: "Minimum Yelp Rating", size: 20)
    private var sliderLeftLabel     = GenericLabel(text: "1")
    private var sliderRightLabel    = GenericLabel(text: "5")
    private var priceLabel          = GenericLabel(text: "Price Filter Options",  size: 20)
    private var noPriceLabel        = GenericLabel(text: "Include if No Price Listed:", size: 18)
    private var favoriteAtTopLabel  = GenericLabel(text: "Move favorites to top:", size: 18)
    var dollarOneButton     = GenericSegmentButton(title: "$", isCorner: true, corners: [.layerMinXMinYCorner, .layerMinXMaxYCorner])
    var dollarTwoButton     = GenericSegmentButton(title: "$$")
    var dollarThreeButton   = GenericSegmentButton(title: "$$$")
    var dollarFourButton    = GenericSegmentButton(title: "$$$$", isCorner: true, corners: [.layerMaxXMinYCorner, .layerMaxXMaxYCorner])
    var defaultButton       = GenericButton(title: "Reset to Defaults", titleColor: .black, backgroundColor: .white, isCorner: true)
    var saveButton          = GenericButton(title: "SAVE", isCorner: true)
    var cancelButton        = GenericButton(title: "CANCEL", isCorner: true)
    var noPriceSwitch       = GenericSwitch(onTintColor: .green)
    var favoriteAtTopSwitch = GenericSwitch(onTintColor: .green)
    private var minimumRatingText   : String!
    private var sliderValue         : Float!
    
    lazy var sliderValueLabel   = GenericLabel(text: minimumRatingText, size: 24, backgroundColor: .blue, textColor: .white, corner: true)
    lazy var distanceSlider     = GenericSlider(min: 1.0, max: 5.0, value: sliderValue, minColor: .gray, maxColor: .black, thumbColor: .white)
    
    private func updateButtonColors(){
        let allDollarButtons   = [dollarOneButton, dollarTwoButton, dollarThreeButton, dollarFourButton]
        allDollarButtons.forEach{$0.backgroundColor = $0.isSelected ? .white : .clear}
    }
    
    private func getFavoritesAtTopStack()->UIStackView{
        let isPriceListedStack =  GenericStack(spacing: 2, axis: .horizontal)
        [favoriteAtTopLabel, favoriteAtTopSwitch].forEach{isPriceListedStack.addArrangedSubview($0)}
        return isPriceListedStack
    }
    
    private func getNoPriceStack()->UIStackView{
        let isPriceListedStack =  GenericStack(spacing: 2, axis: .horizontal)
        [noPriceLabel, noPriceSwitch].forEach{isPriceListedStack.addArrangedSubview($0)}
        return isPriceListedStack
    }
    
    private func getSliderValueLabelStack()->UIStackView{
        let stack = GenericStack(spacing: 0, axis: .horizontal, distribution: .fillEqually)
        let fillerLabel = GenericLabel(text: " ")
        let fillerLabel2 = GenericLabel(text: " ")
        [fillerLabel, sliderValueLabel, fillerLabel2].forEach{stack.addArrangedSubview($0)}
        return stack
    }
    
    private func getSliderStack()->UIStackView{
        sliderLeftLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        sliderRightLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        let sliderStack = GenericStack(spacing: 2, axis: .horizontal)
        [sliderLeftLabel, distanceSlider, sliderRightLabel].forEach{sliderStack.addArrangedSubview($0)}
        return sliderStack
    }
    
    private func getDollarStack()->UIStackView{
        let dollarStack = GenericStack(spacing: 1, axis: .horizontal, distribution: .fillEqually)
        [dollarOneButton, dollarTwoButton, dollarThreeButton, dollarFourButton].forEach{dollarStack.addArrangedSubview($0)}
        return dollarStack
    }
    
    func getFullStack()->UIStackView{
        let fullStack = GenericStack(spacing: 20, axis: .vertical)
        [priceLabel, getDollarStack(), sliderLabel, getSliderStack(), getSliderValueLabelStack(), getFavoritesAtTopStack(),
         getNoPriceStack(), saveButton, cancelButton, defaultButton].forEach{fullStack.addArrangedSubview($0)}
        return fullStack
    }
}
