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
    let window          : UIWindow
    let dataController  : DataController
    let firstController : MainMenuController
    
    init(router: RouterType, dataController: DataController, window: UIWindow, vc: MainMenuController) {
        self.dataController = dataController
        self.window         = window
        firstController     = vc
        super.init(router: router)
        router.setRootModule(vc, hideBar: false)
    }
    
    override func start(){
        firstController.coordinator = self
        window.rootViewController   = router.toPresentable()
        window.makeKeyAndVisible()
    }
    
    func loadSearchTable(dataController: DataController, location: CLLocation){
        let coordinator = OpeningCoordinator(dataController: dataController, router: router, location: location)
        addChild(coordinator)
        coordinator.start(parent: self)
        router.push(coordinator, animated: true) {[weak self, weak coordinator] in
            self?.removeChild(coordinator)
        }
    }
    func loadSearchByMap(dataController: DataController, location: CLLocation){
        let coordinator = SearchByMapCoordinator(dataController: dataController, router: router, location: location)
        addChild(coordinator)
        coordinator.start(parent: self)
        router.push(coordinator, animated: true) {[weak self, weak coordinator] in
            self?.removeChild(coordinator)
        }
    }
    
    func loadSearchByAddress(dataController: DataController, location: CLLocation){
        let coordinator = SearchByAddressCoordinator(dataController: dataController, router: router, location: location)
        addChild(coordinator)
        coordinator.start(parent: self)
        router.push(coordinator, animated: true) {[weak self, weak coordinator] in
            self?.removeChild(coordinator)
        }
    }

    func loadSettings(dataController: DataController, delegate: UnBlurViewProtocol, max: Int?) {
        let coordinator = SettingsCoordinator(unblurProtocol: delegate, dataController: dataController, router: router)
        coordinator.start(parent: self)
    }
}
