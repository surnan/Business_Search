//
//  MainCoordinator.swift
//  Business_Search
//
//  Created by admin on 7/16/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import MapKit

class MenuCoordinator: NavigationCoordinator, PushOpen, PushSearchByMap, PushSearchByAddress, PresentSettings {
    var dataController: DataController
    init(navigationController: UINavigationController, dataController: DataController) {
        self.dataController = dataController
        super.init(navigationCoordinator: navigationController)
    }
    
    override func start() {
        let vc = MenuController()
        vc.dataController = dataController
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func pushOpenCoordinator(userLocation: CLLocation){
        let newCoordinator = OpeningCoordinator(navigationController: navigationController,
                                                 dataController: dataController,
                                                 userLocation: userLocation)
        newCoordinator.start()
    }
    
    func pushSearchByMapCoordinator(location: CLLocation){
        let newCoordinator = SearchByMapCoordinator(navigationController: navigationController,
                                                    location: location,
                                                    dataController: dataController)
        newCoordinator.start()
    }
    
    func pushSearchByAddressCoordinator(location: CLLocation){
        let newCoordinator = SearchByAddressCoordinator(navigationController: navigationController,
                                                        location: location,
                                                        dataController: dataController)
        newCoordinator.start()
    }
    
    func presentSettingsCoordinator(destination: UIViewController){
        let newCoordinator = PresentSettingsCoordinator(presenting: destination,
                                                        dataController: dataController)
        newCoordinator.start()
    }
}
