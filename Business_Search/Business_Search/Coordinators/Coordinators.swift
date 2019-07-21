//
//  Coordinators.swift
//  Business_Search
//
//  Created by admin on 7/19/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import MapKit

protocol BaseCoordinatorType: class {
    func start()
}

protocol PresentableCoordinatorType: BaseCoordinatorType, Presentable {}

class PresentableCoordinator: NSObject, PresentableCoordinatorType {
    override init() {super.init()}
    open func start() {}
    open func toPresentable() -> UIViewController {fatalError("Must override toPresentable()")}
}

protocol CoordinatorType: PresentableCoordinatorType {
    var router: RouterType { get }
}

class Coordinator: PresentableCoordinator, CoordinatorType  {
    var childCoordinators: [Coordinator] = []
    var router: RouterType
    init(router: RouterType) {
        self.router = router
        super.init()
    }
    func addChild(_ coordinator: Coordinator) {childCoordinators.append(coordinator)}
    override func toPresentable() -> UIViewController {return router.toPresentable()}
    func removeChild(_ coordinator: Coordinator?) {
        if let coordinator = coordinator, let index = childCoordinators.firstIndex(of: coordinator) {
            childCoordinators.remove(at: index)
        }
    }
}



protocol SettingsType {func handleSettings()}
protocol OpeningType {func handleOpenController(dataController: DataController, location: CLLocation)}
protocol SearchByMapType {func handleSearchByMap(dataController: DataController, location: CLLocation)}
protocol SearchByAddressType {func handleSearchByAddress(dataController: DataController, location: CLLocation)}

class AppCoordinator: Coordinator, SettingsType, OpeningType, SearchByAddressType, SearchByMapType {
    let window          : UIWindow
    let dataController  : DataController
    let firstVC         : MenuController
    
    init(window: UIWindow?, dataController: DataController) {
        guard let window = window else {fatalError("Window creation needed in AppDelegate")}
        self.window                     = window
        self.dataController             = dataController
        self.firstVC                    = MenuController()
        self.firstVC.dataController     = dataController
        let appNavigationController     = CustomNavigationController(rootViewController: firstVC)
        let appRouter                   = Router(navigationController: appNavigationController)
        super.init(router: appRouter)
    }
    
    override func start() {
        let coordinator = MenuCoordinator(router: router, dataController: dataController, window: window, vc: firstVC)
        coordinator.start()
    }
    
    func handleSettings(){}
    func handleOpenController(dataController: DataController, location: CLLocation){}
    func handleSearchByMap(dataController: DataController, location: CLLocation){}
    func handleSearchByAddress(dataController: DataController, location: CLLocation){}
}

class MenuCoordinator: Coordinator, OpeningType, SearchByAddressType, SearchByMapType, SettingsType {
    var dataController  : DataController
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
    
    func handleOpenController(dataController: DataController, location: CLLocation){
        let coordinate = location.coordinate
        let vc = OpeningController()
        vc.dataController = dataController
        vc.latitude = coordinate.latitude
        vc.longitude = coordinate.longitude
        router.push(vc, animated: true, completion: nil)
    }
    
    func handleSearchByMap(dataController: DataController, location: CLLocation){
        let vc = SearchByMapController()
        vc.dataController = dataController
        vc.possibleInsertLocationCoordinate = location
        router.push(vc, animated: true, completion: nil)
    }
    
    func handleSearchByAddress(dataController: DataController, location: CLLocation){
        let vc = SearchByAddressController()
        vc.dataController = dataController
        router.push(vc, animated: true, completion: nil)
    }
    
    func handleSettings(){}
}
