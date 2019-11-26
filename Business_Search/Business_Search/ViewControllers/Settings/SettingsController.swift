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
    var viewObject          : SettingsView!         //SearchByMapView!
    var viewModel           : SettingsViewModel!    //SearchByMapViewModel!
    var locationsViewModel  : LocationViewModel!
    var favoritesViewModel  : FavoritesViewModel!
    var businessViewModel   : BusinessViewModel!
    
    
    var dismissCleanly      : (()->Void)?
    var loadFilter          : (()->Void)?
    
    var filterType: LoadFilterType!
    
    let loadFilterbutton: UIButton = {
        let button = UIButton()
        button.setTitle("Load Filter", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        button.addTarget(self, action: #selector(handleLoadFilterButton), for: .touchDown)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
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

