//
//  File.swift
//  Business_Search
//
//  Created by admin on 7/16/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import MapKit

class OpeningCoordinator: NavigationCoordinator {
    var dataController: DataController
    var latitude: Double
    var longitude: Double
    
    init(navigationController: UINavigationController, dataController: DataController, userLocation: CLLocation) {
        self.dataController = dataController
        self.latitude = userLocation.coordinate.latitude
        self.longitude = userLocation.coordinate.longitude
        super.init(navigationCoordinator: navigationController)
    }
    
    override func start() {
        let vc = OpeningController()
        vc.dataController = dataController
        vc.latitude = latitude
        vc.longitude = longitude
        navigationController.pushViewController(vc, animated: true)
    }
}
