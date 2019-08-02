//
//  AppCoordinator.swift
//  Business_Search
//
//  Created by admin on 7/21/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import MapKit

class AppCoordinator: Coordinator, SearchTableType, SearchByAddressType, SearchByMapType {
    let window          : UIWindow
    let dataController  : DataController
    let firstVC         : MainMenuController
    
    init(window: UIWindow?, dataController: DataController) {
        guard let window = window else {fatalError("Window creation needed in AppDelegate")}
        self.window                     = window
        self.dataController             = dataController
        self.firstVC                    = MainMenuController()
        let appNavigationController     = CustomNavigationController(rootViewController: firstVC)
        let appRouter                   = Router(navigationController: appNavigationController)
        super.init(router: appRouter)
    }
    
    override func start() {
        let coordinator = MenuCoordinator(router: router, dataController: dataController, window: window, vc: firstVC)
        coordinator.start()
    }
    
    func handlSettings(self viewController: UnBlurViewType, dataController: DataController) {}
    func loadSearchTable(location: CLLocation){}
    func loadSearchByMap(location: CLLocation){}
    func loadSearchByAddress(location: CLLocation){}
}
