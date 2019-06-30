//
//  SettingsModel.swift
//  Business_Search
//
//  Created by admin on 6/29/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit


class SettingsModel {
    
    init(maximumSliderValue: Int? = nil){
        //radius is declared in AppDelegate
        distanceSlider.value = Float(radius)
        sliderValueLabel.text = String(radius)
        deleteAllLabel.isHidden = true
        if let maximumSliderValue = maximumSliderValue {
            distanceSlider.maximumValue = Float(maximumSliderValue)
            sliderRightLabel.text = "\(maximumSliderValue)"
        }
    }
    
    let textViewText = UserDefaults.standard.object(forKey: AppConstants.greetingMessage.rawValue) as? String
        ?? "Hi.  This is the Yelp page for a business that I am looking at: "
    
    //MARK:- VAR
    let sliderLeftLabel     = GenericLabel(text: "0", size: 15, textColor: .white)
    let sliderRightLabel    = GenericLabel(text: "1000", size: 15, textColor: .white)
    let deleteAllLabel      = GenericLabel(text: "All saved business data deleted", size: 12,
                                           backgroundColor: .clear, textColor: .red)
    let myTextViewLabel     = GenericAttributedTextLabel(text: "All outgoing messages include:",
                                                         attributes: whiteHelvetica_20_blackStroke)
    let searchRadiusLabel   = GenericAttributedTextLabel(text: "Meters to Search for Business",
                                                         attributes: whiteHelvetica_20_blackStroke)
    let saveButton          = GenericButton(title: "SAVE", isCorner: true)
    let cancelButton        = GenericButton(title: "CANCEL", isCorner: true)
    let defaultsButton     = GenericButton(title: "Reset to Defaults", isCorner: true)
    
    
    //MARK: Lazy VAR
    lazy var sliderValueLabel   = GenericLabel(text: "\(Int(radius))", size: 20,
                                             backgroundColor: .blue, textColor: .white, corner: true)
    lazy var distanceSlider     = GenericSlider(min: 0, max: 1000, value: Float(radius),
                                            minColor: .gray, maxColor: .black, thumbColor: .white)
    lazy var myTextView         = genericTextView(text: textViewText, size: 12, corner: true)
    
    func getDistanceSliderStack()-> UIStackView {
        let stack = GenericStack(spacing: 10, axis: .horizontal)
        [sliderLeftLabel, distanceSlider, sliderRightLabel].forEach{stack.addArrangedSubview($0)}
        return stack
    }
    
    func getSearchStack()-> UIStackView {
        let stack = GenericStack(spacing: 20, axis: .vertical)
        [searchRadiusLabel, getDistanceSliderStack(), sliderValueLabel].forEach{stack.addArrangedSubview($0)}
        return stack
    }
    
    func getTextViewStack()-> UIStackView {
        let stack = GenericStack(spacing: 20)
        [myTextViewLabel, myTextView].forEach{stack.addArrangedSubview($0)}
        return stack
    }
    
    func getSaveCancelStack()-> UIStackView {
        let stack = GenericStack(spacing: 20)
        [saveButton, cancelButton, defaultsButton, deleteAllLabel].forEach{stack.addArrangedSubview($0)}
        return stack
    }
}
