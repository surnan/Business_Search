//
//  Coordinator Protocol.swift
//  Business_Search
//
//  Created by admin on 7/7/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

protocol Coordinator {
    var childCoordinators: [Coordinator] {get set}
    var navigationController: UINavigationController {get set}
    func start()
}

class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var dataController: DataController
    
    init(navigationController: UINavigationController, dataController: DataController){
        self.navigationController = navigationController
        self.dataController = dataController
    }
    
    
    func start(){
        let vc = MenuController()
        vc.dataController = dataController
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func pushSearchByAddress(location: CLLocation, dataController: DataController){
        let vc = SearchByAddressController(location: location, dataController: dataController)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    
    func pushSearchByMap(location: CLLocation, dataController: DataController){
        let vc = SearchByMapController(location: location, dataController: dataController)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
}


/*
class MainCoordinator: Coordinator {
    var children = [Coordinator]()
    func start(){
        let vc = ViewController()
        vc.coordinator = self
        nav.push(vc, animated: false)
    }
}

//Inside VC
func userTapped(widget: Int){
    let vc = NextViewController()
    vc.widgetToBuy = widget
    present(vc, animated: true)
}
 CONVERTS TO
 func userTapped(widget: Int){
    coordinator?.buy(widget)
 }
*/
