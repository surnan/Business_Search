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
    var viewObject              : FilterView2!
    var viewModel               : FilterViewModel2!
    
    var dismissController       : (()->Void)?
    var saveDismissController   : (()->Void)?
    
    lazy var allDollarButtons   = [viewObject.dollarOneButton, viewObject.dollarTwoButton,
                                   viewObject.dollarThreeButton,viewObject.dollarFourButton]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor                = .clear
        setupUI()
        addHandlers()
    }
}
