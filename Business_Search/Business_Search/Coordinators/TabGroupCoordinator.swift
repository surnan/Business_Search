//
//  MyTabCoordinator.swift
//  Business_Search
//
//  Created by admin on 7/23/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class TabGroupCoordinator: Coordinator, UITabBarControllerDelegate {
    var tabs = [UIViewController: Coordinator]()
    let tabBarController = UITabBarController()
    
    let businesses: [Business]
    let categoryName: String
    
    lazy var groupsCoordinator: GroupTableViewCoordinator = {
        let navigationController = CustomNavigationController()
        navigationController.tabBarItem = UITabBarItem(title: "List", image: #imageLiteral(resourceName: "menu100B"), tag: 0)
        let router = Router(navigationController: navigationController)
        let coordinator = GroupTableViewCoordinator(businesses: businesses, categoryName: categoryName, router: router)
        coordinator.parent = self
        return coordinator
    }()
    
    lazy var mapCoordinator: GroupMapCoordinator = {
        let navigationController = CustomNavigationController()
        navigationController.tabBarItem = UITabBarItem(title: "Map", image: #imageLiteral(resourceName: "map100"), tag: 1)
        let router = Router(navigationController: navigationController)
        let coordinator = GroupMapCoordinator(businesses: businesses, categoryName: categoryName, router: router)
        coordinator.parent = self
        return coordinator
    }()
    
    init(businesses: [Business], categoryName: String, router: RouterType) {
        self.businesses     = businesses
        self.categoryName   = categoryName
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


