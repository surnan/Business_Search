//
//  AppCoordinator.swift
//  Business_Search
//
//  Created by admin on 7/19/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

//protocol BaseCoordinatorType {
//    func start()
//}


//protocol CoordinatorType: BaseCoordinatorType, Presentable {}
//
//class Coordinator: NSObject, CoordinatorType {
//    var childCoordinators: [Coordinator]
//    var router: RouterType
//    init(router: RouterType) {
//        self.router = router
//        childCoordinators = [Coordinator]()
//    }
//    //  FUNC
//    func start() {fatalError("Must override func start") }
//    func toPresentable() -> UIViewController {fatalError("Must override toPresentable")}
//    func addChild(_ coordinator: Coordinator) {childCoordinators.append(coordinator)}
//    func removeChild(_ coordinator: Coordinator?) {
//        if let coordinator = coordinator, let index = childCoordinators.firstIndex(of: coordinator) {
//            childCoordinators.remove(at: index)
//        }
//    }
//}
//
//
//class AppCoordinatae: Coordinator {
//    let dataController: DataController
//    
//    override func start() {
//        let vc = MenuController()
//        vc.dataController = dataController
//        
//        let rootController = CustomNavigationController(rootViewController: vc)
//        router.push(rootController, animated: true, completion: nil)
//    }
//    
//    init(router: Router, dataController: DataController){
//        self.dataController = dataController
//        super.init(router: router)
//    }
//}





/*
 class AppCoordinator2: Coordinator2 {
 var childCoordinators = [Coordinator2]()
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
 //        let navController = UINavigationController()
 //        let menuCoordinator = MenuCoordinator(navigationController: navController, dataController: dataController)
 //        self.store(coordinator: menuCoordinator)
 //        menuCoordinator.start()
 //        window.rootViewController = navController
 //        window.makeKeyAndVisible()
 //        menuCoordinator.isComplete =  {[weak self] in
 //            self?.free(coordinator: menuCoordinator)
 //        }
 }
 }
 */
