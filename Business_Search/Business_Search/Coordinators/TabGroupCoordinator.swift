//
//  MyTabCoordinator.swift
//  Business_Search
//
//  Created by admin on 7/23/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import MapKit

class TabGroupCoordinator: Coordinator, UITabBarControllerDelegate {
    var tabs = [UIViewController: Coordinator]()
    let tabBarController = UITabBarController()
    
    let businesses: [Business]
    let categoryName: String
    let dataController: DataController
    var location: CLLocation!
    
    lazy var groupsCoordinator: GroupTableViewCoordinator = {
        let navigationController = CustomNavigationController()
        navigationController.tabBarItem = UITabBarItem(title: "LIST", image: #imageLiteral(resourceName: "menu100B"), tag: 0)
        let router = Router(navigationController: navigationController)
        let coordinator = GroupTableViewCoordinator(dataController: dataController, businesses: businesses, categoryName: categoryName, router: router, location: location)
        coordinator.parent = self
        return coordinator
    }()
    
    lazy var mapCoordinator: GroupMapCoordinator = {
        let navigationController = CustomNavigationController()
        navigationController.tabBarItem = UITabBarItem(title: "MAP", image: #imageLiteral(resourceName: "map100"), tag: 1)
        let router = Router(navigationController: navigationController)
        let coordinator = GroupMapCoordinator(dataController: dataController, businesses: businesses, categoryName: categoryName, router: router)
        coordinator.parent = self
        return coordinator
    }()
    
    init(dataController: DataController, businesses: [Business], categoryName: String, router: RouterType, location: CLLocation) {
        self.dataController = dataController
        self.businesses     = businesses
        self.categoryName   = categoryName
        self.location = location
        super.init(router: router)
        tabBarController.delegate = self
        setTabs([groupsCoordinator, mapCoordinator])
    }
    
    func setTabs(_ coordinators: [Coordinator], animated: Bool = false) {
        tabs = [:]
        let vcs = coordinators.map { coordinator -> UIViewController in
            let viewController = coordinator.toPresentable()
            tabs[viewController] = coordinator
            return viewController
        }
        tabBarController.setViewControllers(vcs, animated: animated)
    }
    
    override func start() {
        guard let index = tabBarController.viewControllers?.firstIndex(of: groupsCoordinator.toPresentable()) else {return}
        tabBarController.selectedIndex = index
    }
    
    func start(parent: Coordinator) {
        router.present(tabBarController, animated: true)
    }
    
    func dismissTabController(){
        router.dismissModule(animated: true, completion: nil)
    }
}


