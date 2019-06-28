//
//  FilterController.swift
//  Business_Search
//
//  Created by admin on 6/3/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData

class FilterController: UIViewController {
    let minimumRatingText = UserAppliedFilter.shared.getMinimumRatingString
    let sliderValue = UserAppliedFilter.shared.getMinimumRatingFloat

    var delegate: MenuControllerDelegate?
    
    //  MYLabel
    var sliderLabel = MyLabel(text: "Minimum Yelp Rating", size: 20)
    var sliderLeftLabel = MyLabel(text: "1")
    var sliderRightLabel = MyLabel(text: "5")
    var priceLabel = MyLabel(text: "Price Filter Options",  size: 20)
    var noPriceLabel = MyLabel(text: "Include if No Price Listed: ", size: 18)
    
    //  SegmentButton
    lazy var dollarOneButton = SegmentButton(title: "$", isCorner: true, corners: [.layerMinXMinYCorner, .layerMinXMaxYCorner])
    lazy var dollarTwoButton = SegmentButton(title: "$$")
    lazy var dollarThreeButton = SegmentButton(title: "$$$")
    lazy var dollarFourButton = SegmentButton(title: "$$$$", isCorner: true, corners: [.layerMaxXMinYCorner, .layerMaxXMaxYCorner])
    
    //  MYButton
    lazy var sliderValueLabel = MyLabel(text: minimumRatingText, size: 24, backgroundColor: .blue, textColor: .white, corner: true)
    lazy var defaultButton = MYButton(title: "Reset to Defaults", titleColor: .black, backgroundColor: .white, isCorner: true)
    lazy var saveButton = MYButton(title: "SAVE", titleColor: .black, backgroundColor: .white, isCorner: true)
    lazy var cancelButton = MYButton(title: "CANCEL", titleColor: .black, backgroundColor: .white, isCorner: true)

    //  MYSwitch & MYSlider
    lazy var noPriceSwitch = MYSwitch(onTintColor: .green)
    lazy var distanceSlider = MYSlider(min: 1.0, max: 5.0, value: sliderValue,
                                       minColor: .gray, maxColor: .black, thumbColor: .white)

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let shared = UserAppliedFilter.shared
        //shared.showMyResultsInNSUserDefaults(); print("***")
        dollarOneButton.isSelected = shared.getOne
        dollarTwoButton.isSelected = shared.getTwo
        dollarThreeButton.isSelected = shared.getThree
        dollarFourButton.isSelected = shared.getFour
        noPriceSwitch.isOn = shared.getNoPrice
        [dollarOneButton, dollarTwoButton, dollarThreeButton, dollarFourButton].forEach{$0.backgroundColor = $0.isSelected ? .white : .clear}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        addHandlers()
        let dollarStack = MYStack(spacing: 1, axis: .horizontal, distribution: .fillEqually)
        let sliderStack = MYStack(spacing: 10, axis: .horizontal)
        let isPriceListedStack = MYStack(spacing: 20, axis: .horizontal)
        let _myStack = MYStack(spacing: 20, axis: .vertical)

        [sliderLeftLabel, distanceSlider, sliderRightLabel].forEach{sliderStack.addArrangedSubview($0)}
        [dollarOneButton, dollarTwoButton, dollarThreeButton, dollarFourButton].forEach{dollarStack.addArrangedSubview($0)}
        [noPriceLabel, noPriceSwitch].forEach{isPriceListedStack.addArrangedSubview($0)}
        [priceLabel, dollarStack, sliderLabel, sliderStack, sliderValueLabel,
         isPriceListedStack, saveButton, cancelButton, defaultButton].forEach{_myStack.addArrangedSubview($0)}
        
        view.addSubview(_myStack)
        _myStack.centerToSuperView()
        _myStack.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75).isActive = true
    }
    
    //MARK:- Handlers
    func addHandlers(){
        defaultButton.addTarget(self, action: #selector(handleResetToDefaultsButton), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(handleSaveButton), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(handleCancelButton), for: .touchUpInside)
        distanceSlider.addTarget(self, action: #selector(handleSliderValueChange(_:forEvent:)), for: .valueChanged)
        [dollarOneButton, dollarTwoButton, dollarThreeButton, dollarFourButton].forEach{
            $0.addTarget(self, action: #selector(handleDollarButtons(_:)), for: .touchDown)
        }
    }
    
    @objc func handleSliderValueChange(_ sender: UISlider, forEvent event: UIEvent){
        let temp = sender.value.rounded(digits: 1)
        sliderValueLabel.text = "\(temp)"
    }
    
    @objc func handleDollarButtons(_ sender: CustomButton){sender.isSelected = !sender.isSelected}
    @objc func handleCancelButton(){dismiss(animated: true, completion: {self.delegate?.undoBlur()})}
    
    @objc func handleSaveButton(){
        UserAppliedFilter.shared.save(dollarOne: dollarOneButton.isSelected,
                                      dollarTwo: dollarTwoButton.isSelected,
                                      dollarThree: dollarThreeButton.isSelected,
                                      dollarFour: dollarFourButton.isSelected,
                                      noPrices: noPriceSwitch.isOn,
                                      minimumRating: sliderValueLabel.text ?? "0.0")
        self.dismiss(animated: true, completion: {
            UserAppliedFilter.shared.load()
            self.delegate?.undoBlur()
            _ = UserAppliedFilter.shared.getBusinessPredicate()
        })
    }
    
    @objc func handleResetToDefaultsButton(){
        [dollarOneButton, dollarTwoButton, dollarThreeButton, dollarFourButton].forEach{$0.isSelected = true; $0.backgroundColor = .white}
        [noPriceSwitch].forEach{$0.isOn = true}
        distanceSlider.value = 1.0
        sliderValueLabel.text = "1.0"
    }
}










