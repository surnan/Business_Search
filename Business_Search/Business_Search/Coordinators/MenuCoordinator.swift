//
//  MenuCoordinator.swift
//  Business_Search
//
//  Created by admin on 7/21/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import MapKit

//protocol SettingsType {func handlSettings(self viewController: UnBlurViewProtocol, dataController: DataController)}
protocol OpeningType {func handleOpenController(dataController: DataController, location: CLLocation)}
protocol SearchByMapType {func handleSearchByMap(dataController: DataController, location: CLLocation)}
protocol SearchByAddressType {func handleSearchByAddress(dataController: DataController, location: CLLocation)}
protocol SettingsType {func handleSettings(dataController: DataController, delegate: UnBlurViewProtocol)}


class MenuCoordinator: Coordinator, OpeningType, SearchByAddressType, SearchByMapType, SettingsType {
    let dataController  : DataController
    let window          : UIWindow
    let firstController : MenuController
    
    init(router: RouterType, dataController: DataController, window: UIWindow, vc: MenuController) {
        self.dataController = dataController
        self.window         = window
        firstController     = vc
        super.init(router: router)
    }
    
    override func start(){
        firstController.coordinator = self
        window.rootViewController       = router.toPresentable()
        window.makeKeyAndVisible()
    }
    
    //var childCoordinators: [Coordinator] = []
    func handleOpenController(dataController: DataController, location: CLLocation){
        let coordinator = OpenCoordinator(dataController: dataController, router: router, location: location)
        addChild(coordinator)
        coordinator.start(parent: self)
    }
    
    func handleSettings(dataController: DataController, delegate: UnBlurViewProtocol) {
        let coordinator = SettingsCoordinator(unblurProtocol: delegate, dataController: dataController, router: router)
        coordinator.start(parent: self)
    }
    
    func handleSearchByMap(dataController: DataController, location: CLLocation){
        let coordinator = SearchByMapCoordinator(dataController: dataController, router: router, location: location)
        addChild(coordinator)
        coordinator.start()
        router.push(coordinator, animated: true) {[weak self, weak coordinator] in
            self?.removeChild(coordinator)
            print("Popped")
        }
    }
    
    func handleSearchByAddress(dataController: DataController, location: CLLocation){
        let coordinator = SearchByAddressCoordinator(dataController: dataController, router: router, location: location)
        addChild(coordinator)
        coordinator.start()
        router.push(coordinator, animated: true) {[weak self, weak coordinator] in
            self?.removeChild(coordinator)
            print("Popped")
        }
    }
    
    func handlSettings(self viewController: UnBlurViewProtocol, dataController: DataController){
        let coordinator = SettingsCoordinator(unblurProtocol: viewController, dataController: dataController, router: router)
        addChild(coordinator)
        coordinator.start()
        router.push(coordinator, animated: true) {[weak self, weak coordinator] in
            self?.removeChild(coordinator)
            print("Popped")
        }
    }
}
