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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor                = .clear
        setupUI()
        //shared.showMyResultsInNSUserDefaults(); print("***")
        addHandlers()
    }
}