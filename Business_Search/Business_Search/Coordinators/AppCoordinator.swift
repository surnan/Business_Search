////
////  AppCoordinator.swift
////  Business_Search
////
////  Created by admin on 7/19/19.
////  Copyright © 2019 admin. All rights reserved.
////
//
//import UIKit
//
//class AppCoordinator: Coordinator, UINavigationControllerDelegate {
//    var dataController: DataController
//
//
//    let vc = MenuController(nibName: nil, bundle: nil)
//
//    lazy var navController = CustomNavigationController(rootViewController: vc)
//
//    init(router: RouterType, dataController: DataController) {
//        self.dataController = dataController
//        super.init(router: router)
//        //router.setRootModule(navController, hideBar: false)
//    }
//
//    override func start(){
////                let vc = MenuController()
////                vc.dataController = dataController
////                let navController = CustomNavigationController(rootViewController: vc)
////                window = UIWindow(frame: UIScreen.main.bounds) //window = UIWindow()
////                window?.rootViewController = navController
////                window?.makeKeyAndVisible()
//    }
//}
//
//
//class MenuCoordinator: Coordinator{
//    override init(router: RouterType) {
//        super.init(router: router)
//    }
//
//    override func start() {
//    }
//}
