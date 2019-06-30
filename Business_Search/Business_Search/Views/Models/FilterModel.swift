//
//  FilteredControllerUI.swift
//  Business_Search
//
//  Created by admin on 6/29/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData

class FilterModel{
    let minimumRatingText = UserAppliedFilter.shared.getMinimumRatingString
    let sliderValue = UserAppliedFilter.shared.getMinimumRatingFloat
    let shared = UserAppliedFilter.shared
    
    //Mark:- VAR
    var sliderLabel         = GenericLabel(text: "Minimum Yelp Rating", size: 20)
    var sliderLeftLabel     = GenericLabel(text: "1")
    var sliderRightLabel    = GenericLabel(text: "5")
    var priceLabel          = GenericLabel(text: "Price Filter Options",  size: 20)
    var noPriceLabel        = GenericLabel(text: "Include if No Price Listed: ", size: 18)
    
    var dollarOneButton     = GenericSegmentButton(title: "$", isCorner: true, corners: [.layerMinXMinYCorner, .layerMinXMaxYCorner])
    var dollarTwoButton     =  GenericSegmentButton(title: "$$")
    var dollarThreeButton   = GenericSegmentButton(title: "$$$")
    var dollarFourButton    = GenericSegmentButton(title: "$$$$", isCorner: true, corners: [.layerMaxXMinYCorner, .layerMaxXMaxYCorner])

    var defaultButton       = GenericButton(title: "Reset to Defaults", titleColor: .black, backgroundColor: .white, isCorner: true)
    var saveButton          = GenericButton(title: "SAVE", titleColor: .black, backgroundColor: .white, isCorner: true)
    var cancelButton        = GenericButton(title: "CANCEL", titleColor: .black, backgroundColor: .white, isCorner: true)
    
    var noPriceSwitch       = GenericSwitch(onTintColor: .green)
    
    //MARK: Lazy VAR
    lazy var sliderValueLabel   = GenericLabel(text: minimumRatingText, size: 24, backgroundColor: .blue,
                                        textColor: .white, corner: true)
    lazy var distanceSlider     = GenericSlider(min: 1.0, max: 5.0, value: sliderValue, minColor: .gray,
                                       maxColor: .black, thumbColor: .white)
    
    func getSliderStack()->UIStackView{
        let sliderStack = GenericStack(spacing: 10, axis: .horizontal)
        [sliderLeftLabel, distanceSlider, sliderRightLabel].forEach{sliderStack.addArrangedSubview($0)}
        return sliderStack
    }
    
    func getDollarStack()->UIStackView{
        let dollarStack = GenericStack(spacing: 1, axis: .horizontal, distribution: .fillEqually)
        [dollarOneButton, dollarTwoButton, dollarThreeButton, dollarFourButton].forEach{dollarStack.addArrangedSubview($0)}
        return dollarStack
    }
    
    func getPriceStack()->UIStackView{
        let isPriceListedStack =  GenericStack(spacing: 20, axis: .horizontal)
        [noPriceLabel, noPriceSwitch].forEach{isPriceListedStack.addArrangedSubview($0)}
        return isPriceListedStack
    }
    
    func getFullStack()->UIStackView{
        let fullStack = GenericStack(spacing: 20, axis: .vertical)
        [priceLabel, getDollarStack(), sliderLabel, getSliderStack(), sliderValueLabel,
         getPriceStack(), saveButton, cancelButton, defaultButton].forEach{fullStack.addArrangedSubview($0)}
        return fullStack
    }
}
