//
//  MenuCoordinator.swift
//  Business_Search
//
//  Created by admin on 7/21/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import MapKit

class MenuCoordinator: Coordinator, SearchTableType, SearchByAddressType, SearchByMapType, SettingsType {
    private let window          : UIWindow
    private let dataController  : DataController
    private let newController   : MainMenuController
    
    init(router: RouterType, dataController: DataController, window: UIWindow, vc: MainMenuController) {
        self.dataController = dataController
        self.window         = window
        newController       = vc
        super.init(router: router)
        router.setRootModule(vc, hideBar: false)
    }
    
    override func start(){
        let locationViewModel   = LocationViewModel(dataController: dataController)
        let newViewModel        = MainMenuViewModel(dataController: dataController)
        
        newController.coordinator       = self
        newController.locationViewModel = locationViewModel
        newController.viewModel         = newViewModel
        
        window.rootViewController       = router.toPresentable()
        window.makeKeyAndVisible()
    }
    
    func loadSearchTable(location: CLLocation){
        let coordinator = OpenCoordinator(dataController: dataController, router: router, location: location)
        addChild(coordinator)
        coordinator.start(parent: self)
        router.push(coordinator, animated: true) {[weak self, weak coordinator] in
            self?.removeChild(coordinator)
        }
    }
    func loadSearchByMap(location: CLLocation){
        let coordinator = SearchByMapCoordinator(dataController: dataController, router: router, location: location)
        addChild(coordinator)
        coordinator.start(parent: self)
        router.push(coordinator, animated: true) {[weak self, weak coordinator] in
            self?.removeChild(coordinator)
        }
    }
    
    func loadSearchByAddress(location: CLLocation){
        let coordinator = SearchByAddressCoordinator(dataController: dataController, router: router, location: location)
        addChild(coordinator)
        coordinator.start(parent: self)
        router.push(coordinator, animated: true) {[weak self, weak coordinator] in
            self?.removeChild(coordinator)
        }
    }

    func loadSettings(delegate: UnBlurViewType, max: Int?) {
        let coordinator = SettingsCoordinator(unblurProtocol: delegate, dataController: dataController, router: router)
        coordinator.start(parent: self)
    }
}
