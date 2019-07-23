//
//  MyTabCoordinator.swift
//  Business_Search
//
//  Created by admin on 7/23/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class MyTabCoordinator: Coordinator, UITabBarControllerDelegate {
    var tabs = [UIViewController: Coordinator]()
    let tabBarController = UITabBarController()
    
    let businesses: [Business]
    let categoryName: String
    
    lazy var groupsCoordinator: GroupsCoordinator = {
        let navigationController = UINavigationController()
        navigationController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        let router = Router(navigationController: navigationController)
        let coordinator = GroupsCoordinator(businesses: businesses, categoryName: categoryName, router: router)
        return coordinator
    }()
    
    lazy var mapCoordinator: MapsCoordinator = {
        let navigationController = UINavigationController()
        navigationController.tabBarItem = UITabBarItem(tabBarSystemItem: .downloads , tag: 1)
        let router = Router(navigationController: navigationController)
        let coordinator = MapsCoordinator(businesses: businesses, categoryName: categoryName, router: router)
        return coordinator
    }()
    
    init(businesses: [Business], categoryName: String, router: RouterType) {
        self.businesses     = businesses
        self.categoryName   = categoryName
        super.init(router: router)
        //router.setRootModule(tabBarController, hideBar: false)
        //router.setRootModule(tabBarController, hideBar: true)
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
}


