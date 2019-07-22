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
    var delegate: UnBlurViewProtocol?   //Unblur
    
    let shared                  = UserAppliedFilter.shared
    var coordinator             : FilterCoordinator?
    let model                   = FilterModel()
    var dismissController   : (()->Void)?
    lazy var allDollarButtons   = [model.dollarOneButton, model.dollarTwoButton,
                                 model.dollarThreeButton,model.dollarFourButton]
    
    //MARK:- Override Functions
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        model.dollarOneButton.isSelected      = shared.getOne
        model.dollarTwoButton.isSelected      = shared.getTwo
        model.dollarThreeButton.isSelected    = shared.getThree
        model.dollarFourButton.isSelected     = shared.getFour
        model.noPriceSwitch.isOn              = shared.getNoPrice
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
        let fullStackView = model.getFullStack()
        view.addSubview(fullStackView)
        fullStackView.centerToSuperView()
        fullStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75).isActive = true
    }

    
    //MARK: Handlers
    func addHandlers(){
        model.defaultButton.addTarget(self, action: #selector(handleResetToDefaultsButton), for: .touchUpInside)
        model.saveButton.addTarget(self, action: #selector(handleSaveButton), for: .touchUpInside)
        model.cancelButton.addTarget(self, action: #selector(handleCancelButton), for: .touchUpInside)
        model.distanceSlider.addTarget(self, action: #selector(handleSliderValueChange(_:forEvent:)), for: .valueChanged)
        allDollarButtons.forEach{
            $0.addTarget(self, action: #selector(handleDollarButtons(_:)), for: .touchDown)
        }
    }
    
    @objc func handleSliderValueChange(_ sender: UISlider, forEvent event: UIEvent){
        let temp = sender.value.rounded(digits: 1)
        model.sliderValueLabel.text = "\(temp)"
    }
    
    @objc func handleDollarButtons(_ sender: CustomButton){sender.isSelected = !sender.isSelected}
    @objc func handleCancelButton(){dismiss(animated: true, completion: {self.delegate?.undoBlur()})}
    
    @objc func handleSaveButton(){
        UserAppliedFilter.shared.save(dollarOne: model.dollarOneButton.isSelected,
                                      dollarTwo: model.dollarTwoButton.isSelected,
                                      dollarThree: model.dollarThreeButton.isSelected,
                                      dollarFour: model.dollarFourButton.isSelected,
                                      noPrices: model.noPriceSwitch.isOn,
                                      minimumRating: model.sliderValueLabel.text ?? "0.0")
        self.dismiss(animated: true, completion: {
            UserAppliedFilter.shared.load()
            self.delegate?.undoBlur()
            _ = UserAppliedFilter.shared.getBusinessPredicate()
        })
    }
    
    @objc func handleResetToDefaultsButton(){
        [model.noPriceSwitch].forEach{$0.isOn = true}
        model.distanceSlider.value = 1.0
        model.sliderValueLabel.text = "1.0"
        allDollarButtons.forEach{
            $0.isSelected = true
            $0.backgroundColor = .white
        }
    }
}
