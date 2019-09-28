//
//  File.swift
//  Business_Search
//
//  Created by admin on 7/16/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import MapKit

class SearchByMapCoordinator: NavigationCoordinator, PushOpen {
    var location: CLLocation
    var dataController: DataController
    
    init(navigationController: UINavigationController, location: CLLocation, dataController: DataController) {
        self.location = location
        self.dataController = dataController
        super.init(navigationCoordinator: navigationController)
    }
    
    override func start() {
        let vc = SearchByMapController()
        vc.dataController = dataController
        vc.possibleInsertLocationCoordinate = location
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func pushOpenCoordinator(userLocation: CLLocation){
        let newCoordinator = OpeningCoordinator(navigationController: navigationController,
                                                dataController: dataController,
                                                userLocation: userLocation)
        newCoordinator.start()
    }
}
