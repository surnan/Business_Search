////
////  FilteredControllerUI.swift
////  Business_Search
////
////  Created by admin on 6/29/19.
////  Copyright © 2019 admin. All rights reserved.
////
//
//import UIKit
//
//class FilterModel{
//    let minimumRatingText = UserAppliedFilter.shared.getMinimumRatingString
//    let sliderValue = UserAppliedFilter.shared.getMinimumRatingFloat
//    let shared = UserAppliedFilter.shared
//    
//    //Mark:- VAR
//    var sliderLabel         = GenericLabel(text: "Minimum Yelp Rating", size: 20)
//    var sliderLeftLabel     = GenericLabel(text: "1")
//    var sliderRightLabel    = GenericLabel(text: "5")
//    var priceLabel          = GenericLabel(text: "Price Filter Options",  size: 20)
//    var noPriceLabel        = GenericLabel(text: "Include if No Price Listed:", size: 18)
//    var favoriteAtTopLabel  = GenericLabel(text: "Move favorites to top:", size: 18)
//    
//    var dollarOneButton     = GenericSegmentButton(title: "$", isCorner: true, corners: [.layerMinXMinYCorner, .layerMinXMaxYCorner])
//    var dollarTwoButton     =  GenericSegmentButton(title: "$$")
//    var dollarThreeButton   = GenericSegmentButton(title: "$$$")
//    var dollarFourButton    = GenericSegmentButton(title: "$$$$", isCorner: true, corners: [.layerMaxXMinYCorner, .layerMaxXMaxYCorner])
//
//    var defaultButton       = GenericButton(title: "Reset to Defaults", titleColor: .black, backgroundColor: .white, isCorner: true)
//    var saveButton          = GenericButton(title: "SAVE", isCorner: true)
//    var cancelButton        = GenericButton(title: "CANCEL", isCorner: true)
//    
//    var noPriceSwitch       = GenericSwitch(onTintColor: .green)
//    var favoriteAtTopSwitch = GenericSwitch(onTintColor: .green)
//    
//    //MARK: Lazy VAR
//    lazy var sliderValueLabel   = GenericLabel(text: minimumRatingText, size: 24, backgroundColor: .blue,
//                                        textColor: .white, corner: true)
//    lazy var distanceSlider     = GenericSlider(min: 1.0, max: 5.0, value: sliderValue, minColor: .gray,
//                                       maxColor: .black, thumbColor: .white)
//    
//    func getFavoritesAtTopStack()->UIStackView{
//        let isPriceListedStack =  GenericStack(spacing: 2, axis: .horizontal)
//        [favoriteAtTopLabel, favoriteAtTopSwitch].forEach{isPriceListedStack.addArrangedSubview($0)}
//        return isPriceListedStack
//    }
//    
//    func getNoPriceStack()->UIStackView{
//        let isPriceListedStack =  GenericStack(spacing: 2, axis: .horizontal)
//        [noPriceLabel, noPriceSwitch].forEach{isPriceListedStack.addArrangedSubview($0)}
//        return isPriceListedStack
//    }
//    
//    func getSliderValueLabelStack()->UIStackView{
//        let stack = GenericStack(spacing: 0, axis: .horizontal, distribution: .fillEqually)
//        let fillerLabel = GenericLabel(text: " ")
//        let fillerLabel2 = GenericLabel(text: " ")
//        [fillerLabel, sliderValueLabel, fillerLabel2].forEach{stack.addArrangedSubview($0)}
//        return stack
//    }
//    
//    func getSliderStack()->UIStackView{
//        sliderLeftLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
//        sliderRightLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
//        let sliderStack = GenericStack(spacing: 2, axis: .horizontal)
//        [sliderLeftLabel, distanceSlider, sliderRightLabel].forEach{sliderStack.addArrangedSubview($0)}
//        return sliderStack
//    }
//    
//    func getDollarStack()->UIStackView{
//        let dollarStack = GenericStack(spacing: 1, axis: .horizontal, distribution: .fillEqually)
//        [dollarOneButton, dollarTwoButton, dollarThreeButton, dollarFourButton].forEach{dollarStack.addArrangedSubview($0)}
//        return dollarStack
//    }
//    
//    func getFullStack()->UIStackView{
//        let fullStack = GenericStack(spacing: 20, axis: .vertical)
//        [priceLabel, getDollarStack(), sliderLabel, getSliderStack(), getSliderValueLabelStack(), getFavoritesAtTopStack(),
//         getNoPriceStack(), saveButton, cancelButton, defaultButton].forEach{fullStack.addArrangedSubview($0)}
//        return fullStack
//    }
//}
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
