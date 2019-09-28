//
//  AppCoordinator.swift
//  Business_Search
//
//  Created by admin on 7/16/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

protocol Coordinator: AnyObject {   //   !==
    var childCoordinators: [Coordinator] {get set}
    func start()
}

extension Coordinator {     //Extension is only way to get code into function
    func store(coordinator: Coordinator){childCoordinators.append(coordinator)}
    func free(coordinator: Coordinator) {childCoordinators = childCoordinators.filter{$0 !== coordinator}} //Anyobject
}

class AppCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    let window: UIWindow
    let dataController: DataController
    
    init(window: UIWindow?, dataController: DataController){
        guard let window = window else {
            fatalError("Window creation needed in AppDelegate")
        }
        self.window = window
        self.dataController = dataController
    }
    
    func start() {
        let navController = CustomNavigationController()
        let menuCoordinator = MenuCoordinator(navigationController: navController, dataController: dataController)
        self.store(coordinator: menuCoordinator)
        menuCoordinator.start()
        window.rootViewController = navController
        window.makeKeyAndVisible()
        menuCoordinator.isComplete =  {[weak self] in
            self?.free(coordinator: menuCoordinator)
        }
    }
}

class NavigationCoordinator: Coordinator {
    var childCoordinators:  [Coordinator] = []
    var isComplete: (()->())?       //replace last () with Void?
    var navigationController: UINavigationController
    func start(){fatalError("Children should implement 'start'")}
    init(navigationCoordinator: UINavigationController) {
        self.navigationController = navigationCoordinator
    }
}
