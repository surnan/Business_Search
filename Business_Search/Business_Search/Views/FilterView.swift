//
//  FilterView.swift
//  Business_Search
//
//  Created by admin on 7/28/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class FilterView {
    
    private let topStringAttributes: [NSAttributedString.Key: Any]   = [
        .font:UIFont.boldSystemFont(ofSize: 26),
        .underlineStyle : NSUnderlineStyle.single.rawValue,
        .foregroundColor: UIColor.white
    ]
    
    var viewModel: FilterViewModel?{
        didSet{
            guard let viewModel = viewModel else {
                print("SettingsView.ViewModel = NIL")
                return
            }
            minimumRatingText               = viewModel.minimumRating
            sliderValue                     = viewModel.getSliderValue
            dollarOneButton.isSelected      = viewModel.dollarOne
            dollarTwoButton.isSelected      = viewModel.dollarTwo
            dollarThreeButton.isSelected    = viewModel.dollarThree
            dollarFourButton.isSelected     = viewModel.dollarFour
            noPriceSwitch.isOn              = viewModel.priceExist
            favoriteAtTopSwitch.isOn        = viewModel.favoritesTop
            updateButtonColors()
        }
    }
    
    var isFilteredLabel     = GenericLabel(text: "  Selected options are restricting results  ",
                                                   backgroundColor: .red,
                                                   textColor: .white,
                                                   alignment: .center,
                                                   numberOfLines: -1)
    
    
    private var sliderLabel         = GenericLabel(text: "Minimum Customer Rating:", size: 20)
    private var sliderLeftLabel     = GenericLabel(text: "1")
    private var sliderRightLabel    = GenericLabel(text: "5")
    private var priceLabel          = GenericLabel(text: "Price Ranges:",  size: 20)
    private var noPriceLabel        = GenericLabel(text: "Show if No Price Listed:", size: 18)
    private var favoriteAtTopLabel  = GenericLabel(text: "Show Favorites at Top:", size: 18)
    
    private var fillerLabel         = GenericLabel(text: "+ ")
    private var filterTitleLabel    = GenericLabel(text: "FILTER OPTIONS\n\n\n", size: 26)
    private lazy var attribTitle    = GenericAttributedTextLabel(text: "FILTER OPTIONS\n\n\n",
                                                                 attributes: topStringAttributes)
    
    
    func getTitleLabel()->UILabel{
        return filterTitleLabel
    }
    
    let dollarOneButton     = GenericSegmentButton(title: "$", isCorner: true, corners: [.layerMinXMinYCorner, .layerMinXMaxYCorner])
    let dollarTwoButton     = GenericSegmentButton(title: "$$")
    let dollarThreeButton   = GenericSegmentButton(title: "$$$")
    let dollarFourButton    = GenericSegmentButton(title: "$$$$", isCorner: true, corners: [.layerMaxXMinYCorner, .layerMaxXMaxYCorner])
    
    let defaultButton       = GenericButton(title: "Reset to Defaults", titleColor: .black, backgroundColor: .white, isCorner: true)
    let saveButton          = GenericButton(title: "SAVE", isCorner: true)
    let cancelButton        = GenericButton(title: "CANCEL", isCorner: true)
    let noPriceSwitch       = GenericSwitch(onTintColor: .green)
    let favoriteAtTopSwitch = GenericSwitch(onTintColor: .green)
    
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
        let fullStack = GenericStack(spacing: 10, axis: .vertical)
        let priceDollarsView: UIView = getDollarStack()
        let noPriceView: UIView = getNoPriceStack()
        let sliderValueView: UIView = getSliderValueLabelStack()
        
        [attribTitle,
         priceLabel, priceDollarsView,
         sliderLabel, getSliderStack(), sliderValueView,
         getFavoritesAtTopStack(), noPriceView,
         saveButton, cancelButton, defaultButton].forEach{fullStack.addArrangedSubview($0)}
        fullStack.setCustomSpacing(40.0, after: attribTitle)
        fullStack.setCustomSpacing(40.0, after: priceDollarsView)
        fullStack.setCustomSpacing(40.0, after: sliderValueView)
        fullStack.setCustomSpacing(40.0, after: noPriceView)
        return fullStack
    }
}

