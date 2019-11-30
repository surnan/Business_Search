//
//  SettingsController.swift
//  Business_Search
//
//  Created by admin on 5/23/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData


class SettingsController: UIViewController, NSFetchedResultsControllerDelegate {
    var dataController      : DataController!       //injected
    var delegate            : UnBlurViewType?       //Unblur
    var newRadiusValue      : Int!
    var maximumSliderValue  : Int?
    var dismissController   : (()->Void)?
    var coordinator         : Coordinator?
    
    var viewModel           : SettingsViewModel!    //SearchByMapViewModel!
    var locationsViewModel  : LocationViewModel!
    var favoritesViewModel  : FavoritesViewModel!
    var businessViewModel   : BusinessViewModel!
    
    
    var saveCancelDeleteStack: UIStackView!
    var textViewStack: UIStackView!
    var distanceSliderStack: UIStackView!
    var verticalSearchStack: UIStackView!
    var myTextView: GenericTextView!
    
    var viewObject          : SettingsView! {
        didSet {
            saveCancelDeleteStack   = viewObject.getSaveCancelStack()
            textViewStack           = viewObject.getTextViewStack()
            distanceSliderStack     = viewObject.getDistanceSliderStack()
            verticalSearchStack     = viewObject.getSearchStack()
            myTextView              = viewObject.myTextView
        }
    }
    
    var dismissCleanly      : (()->Void)?
    var loadFilter          : (()->Void)?
    
    var filterType: LoadFilterType!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor    = .clear
        view.isOpaque           = false
        setupUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addHandlers()
    }
}

