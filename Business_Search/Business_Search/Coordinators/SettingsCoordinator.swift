//
//  SettingsCoordinator.swift
//  Business_Search
//
//  Created by admin on 7/21/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import MapKit

class SettingsCoordinator: Coordinator {
    private let dataController: DataController
    private var maximumSliderValue: Int?
    var getMaximumSliderValue: Int? {return maximumSliderValue}
    private let unblurProtocol: UnBlurViewType
    
    init(unblurProtocol: UnBlurViewType, dataController: DataController, router: RouterType) {
        self.unblurProtocol = unblurProtocol
        self.dataController = dataController
        super.init(router: router)
    }
    
    init(unblurProtocol: UnBlurViewType, dataController: DataController, router: RouterType, maximumSliderValue: Int? = nil) {
        self.unblurProtocol = unblurProtocol
        self.dataController = dataController
        self.maximumSliderValue = maximumSliderValue
        super.init(router: router)
    }
        
    func start(parent: Coordinator){
        let newViewModel = SettingsViewModel()
        let newViewObject = SettingsView()
        let favoritesViewModel = FavoritesViewModel(dataController: dataController)
        let businessViewModel = BusinessViewModel(dataController: dataController)
        
        newViewObject.viewModel = newViewModel
        let newController = SettingsController()
        newController.locationsViewModel = LocationViewModel(dataController: dataController)
        newController.dataController           = dataController
        newController.viewObject               = newViewObject
        newController.viewModel                = newViewModel
        newController.delegate                 = unblurProtocol
        newController.coordinator              = self
        newController.favoritesViewModel       = favoritesViewModel
        newController.businessViewModel        = businessViewModel
        newController.modalPresentationStyle   = .overFullScreen
        newController.dismissController = {[weak self] in
            self?.router.dismissModule(animated: true, completion: {
                self?.unblurProtocol.undoBlur()
            })
        }
        router.present(newController, animated: true)
    }
}
