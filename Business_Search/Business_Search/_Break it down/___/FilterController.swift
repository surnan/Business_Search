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
    var viewObject              : FilterView!
    var viewModel               : FilterViewModel!
    
    var dismissController       : (()->Void)?
    var saveDismissController   : (()->Void)?
    lazy var allDollarButtons   = [viewObject.dollarOneButton, viewObject.dollarTwoButton,
                                 viewObject.dollarThreeButton,viewObject.dollarFourButton]
    
    //MARK:- Override Functions
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor                = .clear
//        viewObject.dollarOneButton.isSelected    = shared.getOne
//        viewObject.dollarTwoButton.isSelected    = shared.getTwo
//        viewObject.dollarThreeButton.isSelected  = shared.getThree
//        viewObject.dollarFourButton.isSelected   = shared.getFour
//        viewObject.noPriceSwitch.isOn            = shared.getNoPrice
        allDollarButtons.forEach{$0.backgroundColor = $0.isSelected ? .white : .clear}
        setupUI()
        //shared.showMyResultsInNSUserDefaults(); print("***")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addHandlers()
    }
    
    //MARK:- Functions
    func setupUI(){
        let fullStackView = viewObject.getFullStack()
        view.addSubview(fullStackView)
        fullStackView.centerToSuperView()
        fullStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75).isActive = true
    }

    //MARK: Handlers
    func addHandlers(){
        viewObject.defaultButton.addTarget(self, action: #selector(handleResetToDefaultsButton), for: .touchUpInside)
        viewObject.saveButton.addTarget(self, action: #selector(handleSaveButton), for: .touchUpInside)
        viewObject.cancelButton.addTarget(self, action: #selector(handleCancelButton), for: .touchUpInside)
        viewObject.distanceSlider.addTarget(self, action: #selector(handleSliderValueChange(_:forEvent:)), for: .valueChanged)
        allDollarButtons.forEach{
            $0.addTarget(self, action: #selector(handleDollarButtons(_:)), for: .touchDown)
        }
    }
    
    @objc func handleSliderValueChange(_ sender: UISlider, forEvent event: UIEvent){
        let temp = sender.value.rounded(digits: 1)
        viewObject.sliderValueLabel.text = "\(temp)"
    }
    
  @objc func handleDollarButtons(_ sender: CustomButton){sender.isSelected = !sender.isSelected}
    @objc func handleCancelButton(){dismissController?()}
    
    @objc func handleSaveButton(){
        UserAppliedFilter.shared.save(dollarOne: viewObject.dollarOneButton.isSelected,
                                      dollarTwo: viewObject.dollarTwoButton.isSelected,
                                      dollarThree: viewObject.dollarThreeButton.isSelected,
                                      dollarFour: viewObject.dollarFourButton.isSelected,
                                      noPrices: viewObject.noPriceSwitch.isOn,
                                      minimumRating: viewObject.sliderValueLabel.text ?? "0.0",
                                      favoritesAtTop: viewObject.favoriteAtTopSwitch.isOn)
        saveDismissController?()
    }
    
    @objc func handleResetToDefaultsButton(){
        [viewObject.noPriceSwitch].forEach{$0.isOn = true}
        viewObject.distanceSlider.value = 1.0
        viewObject.sliderValueLabel.text = "1.0"
        allDollarButtons.forEach{
            $0.isSelected = true
            $0.backgroundColor = .white
        }
    }
}
