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
    var delegate: MenuControllerDelegate?   //Unblur
    
    let shared                  = UserAppliedFilter.shared
    var filterModel             = FilterModel()
    lazy var allDollarButtons   = [filterModel.dollarOneButton, filterModel.dollarTwoButton,
                                 filterModel.dollarThreeButton,filterModel.dollarFourButton]
    
    //MARK:- Override Functions
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        filterModel.dollarOneButton.isSelected      = shared.getOne
        filterModel.dollarTwoButton.isSelected      = shared.getTwo
        filterModel.dollarThreeButton.isSelected    = shared.getThree
        filterModel.dollarFourButton.isSelected     = shared.getFour
        filterModel.noPriceSwitch.isOn              = shared.getNoPrice
        allDollarButtons.forEach{$0.backgroundColor = $0.isSelected ? .white : .clear}
        setupUI()
        //shared.showMyResultsInNSUserDefaults(); print("***")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        addHandlers()
    }
    
    //MARK:- Functions
    func setupUI(){
        let fullStackView = filterModel.getFullStack()
        view.addSubview(fullStackView)
        fullStackView.centerToSuperView()
        fullStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75).isActive = true
    }

    
    //MARK: Handlers
    func addHandlers(){
        filterModel.defaultButton.addTarget(self, action: #selector(handleResetToDefaultsButton), for: .touchUpInside)
        filterModel.saveButton.addTarget(self, action: #selector(handleSaveButton), for: .touchUpInside)
        filterModel.cancelButton.addTarget(self, action: #selector(handleCancelButton), for: .touchUpInside)
        filterModel.distanceSlider.addTarget(self, action: #selector(handleSliderValueChange(_:forEvent:)), for: .valueChanged)
        allDollarButtons.forEach{
            $0.addTarget(self, action: #selector(handleDollarButtons(_:)), for: .touchDown)
        }
    }
    
    @objc func handleSliderValueChange(_ sender: UISlider, forEvent event: UIEvent){
        let temp = sender.value.rounded(digits: 1)
        filterModel.sliderValueLabel.text = "\(temp)"
    }
    
    @objc func handleDollarButtons(_ sender: CustomButton){sender.isSelected = !sender.isSelected}
    @objc func handleCancelButton(){dismiss(animated: true, completion: {self.delegate?.undoBlur()})}
    
    @objc func handleSaveButton(){
        UserAppliedFilter.shared.save(dollarOne: filterModel.dollarOneButton.isSelected,
                                      dollarTwo: filterModel.dollarTwoButton.isSelected,
                                      dollarThree: filterModel.dollarThreeButton.isSelected,
                                      dollarFour: filterModel.dollarFourButton.isSelected,
                                      noPrices: filterModel.noPriceSwitch.isOn,
                                      minimumRating: filterModel.sliderValueLabel.text ?? "0.0")
        self.dismiss(animated: true, completion: {
            UserAppliedFilter.shared.load()
            self.delegate?.undoBlur()
            _ = UserAppliedFilter.shared.getBusinessPredicate()
        })
    }
    
    @objc func handleResetToDefaultsButton(){
        [filterModel.noPriceSwitch].forEach{$0.isOn = true}
        filterModel.distanceSlider.value = 1.0
        filterModel.sliderValueLabel.text = "1.0"
        allDollarButtons.forEach{
            $0.isSelected = true
            $0.backgroundColor = .white
        }
    }
}
