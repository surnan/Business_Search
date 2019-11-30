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
    var delegate: UnBlurViewType?   //Unblur
    
    let shared                  = UserAppliedFilter.shared
    var coordinator             : FilterCoordinator?
    
    var viewModel               : FilterViewModel!
    
    var dismissController       : (()->Void)?
    var saveDismissController   : (()->Void)?
    
    var dismissCleanly      : (()->Void)?
    
    var isFilteredLabel     : GenericLabel!
    
    
    var allDollarButtons    = [GenericSegmentButton]()

    
    var dollarOneButton     : GenericSegmentButton!
    var dollarTwoButton     : GenericSegmentButton!
    var dollarThreeButton   : GenericSegmentButton!
    var dollarFourButton    : GenericSegmentButton!
    
    var noPriceSwitch       : GenericSwitch!
    var favoriteAtTopSwitch : GenericSwitch!
    var sliderValueLabel    : GenericLabel!
    
    
    var defaultButton : HighlightedButton!
    var saveButton: GenericButton!
    var cancelButton: GenericButton!
    var distanceSlider: GenericSlider!
    
    
    
    var viewObject              : FilterView! {
        didSet{
            isFilteredLabel     = viewObject.isFilteredLabel
            allDollarButtons    = [viewObject.dollarOneButton, viewObject.dollarTwoButton,
                                   viewObject.dollarThreeButton,viewObject.dollarFourButton]
            dollarOneButton     = viewObject.dollarOneButton
            dollarTwoButton     = viewObject.dollarTwoButton
            dollarThreeButton   = viewObject.dollarThreeButton
            dollarFourButton    = viewObject.dollarFourButton
            noPriceSwitch       = viewObject.noPriceSwitch
            favoriteAtTopSwitch = viewObject.favoriteAtTopSwitch
            sliderValueLabel    = viewObject.sliderValueLabel
            
            defaultButton = viewObject.defaultButton
            saveButton = viewObject.saveButton
            cancelButton = viewObject.cancelButton
            distanceSlider = viewObject.distanceSlider
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor                = .clear
        setupUI()
        addHandlers()
    }
}
