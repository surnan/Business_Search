//
//  SettingsView.swift
//  Business_Search
//
//  Created by admin on 7/28/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class SettingsView {
    var viewModel: SettingsViewModel?{
        didSet{
            guard let viewModel = viewModel else {
                print("SettingsView.ViewModel = NIL")
                return
            }
            myTextView.text = viewModel.getTextViewText
            distanceSlider.value = viewModel.getRadiusFloat
            sliderValueLabel.text = viewModel.getRadiusString
        }
    }
    
    let searchRadiusLabel      : GenericAttributedTextLabel = {
        let label = GenericAttributedTextLabel(text: "Search Radius\nin meters",
                                               attributes: whiteHelvetica_20_blackStroke)
        label.numberOfLines = -1
        return label
    }()
    
    let sliderLeftLabel         = GenericLabel(text: "0"        , textColor: .white)
    let sliderRightLabel        = GenericLabel(text: "1000"     , textColor: .white)
    let saveButton              = GenericButton(title: "SAVE"   , titleColor: .white, backgroundColor: .darkBlue, isCorner: true)
    let cancelButton            = GenericButton(title: "CANCEL" , titleColor: .white, backgroundColor: .red, isCorner: true)
    let defaultsButton          = GenericButton(title: "   Delete Saved Data   "      , titleColor: .white, highlightColor: .red, backgroundColor: .darkGreen ,borderWidth: 1, isCorner: true)
    let myTextViewLabel         = GenericAttributedTextLabel(text: "All outgoing messages include:", attributes: whiteHelvetica_20_blackStroke)
    
    
    let loadFilterButton = GenericButton(title: "  Edit Filters ", titleColor: .white, backgroundColor: #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1), isCorner: true)
    
    
    
    let deleteAllLabel: UILabel = {
        let label     = GenericLabel(text: "All favorites and saved business data deleted", size: 12, backgroundColor: .clear, textColor: .red)
        label.isHidden = true
        return label
    }()
    
    let deleteFavoritesLabel: UILabel = {
        let label     = GenericLabel(text: "All favorite deleted", size: 12, backgroundColor: .clear, textColor: .red)
        label.isHidden = true
        return label
    }()
    
    

    //MARK: Lazy VAR
    lazy var sliderValueLabel   = GenericLabel(text: "", size: 20, backgroundColor: .blue, textColor: .white, corner: true)
    lazy var distanceSlider     = GenericSlider(min: 0, max: 1000, value: 0.0, minColor: .gray, maxColor: .black, thumbColor: .white)
    lazy var myTextView         = GenericTextView(text: "", size: 12, corner: true)
    
    func getDistanceSliderStack()-> UIStackView {
        let stack = GenericStack(spacing: 10, axis: .horizontal)
        [sliderLeftLabel, distanceSlider, sliderRightLabel].forEach{stack.addArrangedSubview($0)}
        return stack
    }
    
    func getSearchStack()-> UIStackView {
        let stack = GenericStack(spacing: 20, axis: .vertical, distribution: .fill)
        [searchRadiusLabel, getDistanceSliderStack(), getSliderValueLabelStack()].forEach{stack.addArrangedSubview($0)}
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }
    
    func getSliderValueLabelStack()->UIStackView{
        let stack = GenericStack(spacing: 0, axis: .horizontal, distribution: .fillEqually)
        let fillerLabel = GenericLabel(text: " ")
        let fillerLabel2 = GenericLabel(text: " ")
        [fillerLabel, sliderValueLabel, fillerLabel2].forEach{stack.addArrangedSubview($0)}
        return stack
    }
    
    func getTextViewStack()-> UIStackView {
        let stack = GenericStack(spacing: 20)
        [myTextViewLabel, myTextView].forEach{stack.addArrangedSubview($0)}
        return stack
    }
    
    func getSaveCancelStack()-> UIStackView {
        let stack = GenericStack(spacing: 20)
        [saveButton, cancelButton, defaultsButton, loadFilterButton].forEach{stack.addArrangedSubview($0)}
        return stack
    }
    
    func getDeleteAllLabel()->UILabel{
        return deleteAllLabel
    }
    
    func resetDefaults(){
        radius = defaultRadius
        myTextView.text = defaultOutgoingMessage
        distanceSlider.value =  Float(defaultRadius)
        sliderValueLabel.text = "\(defaultRadius)"
    }
}
