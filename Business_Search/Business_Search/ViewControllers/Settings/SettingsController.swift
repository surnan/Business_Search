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
    var delegate            : UnBlurViewProtocol?   //Unblur
    var newRadiusValue      : Int!
    var maximumSliderValue  : Int?
    var dismissController   : (()->Void)?
    var coordinator         : Coordinator?
    var viewObject          : SettingsView!         //SearchByMapView!
    var viewModel           : SettingsViewModel!    //SearchByMapViewModel!
    lazy var fetchLocation  = LocationNSFetchController(dataController: dataController)

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor    = .clear
        view.isOpaque           = false
        setupUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addHandlers()
        fetchLocation.controller?.delegate = self
    }
}
