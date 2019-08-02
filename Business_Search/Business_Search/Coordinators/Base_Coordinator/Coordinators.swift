//
//  Coordinators.swift
//  Business_Search
//
//  Created by admin on 7/19/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import MapKit

class Coordinator: PresentableType, CoordinatorType  {
    var childCoordinators: [Coordinator] = []
    var router: RouterType
    init(router: RouterType) {
        self.router = router
        super.init()
    }
    
    func addChild(_ coordinator: Coordinator) {
        print("ChildCoordinators before append = \(childCoordinators.count)")
        childCoordinators.append(coordinator)
        print("ChildCoordinators after append = \(childCoordinators.count)")
    }
    
    override func toPresentable() -> UIViewController {return router.toPresentable()}
    
    func removeChild(_ coordinator: Coordinator?) {
        print("ChildCoordinators before removeChild = \(childCoordinators.count)")
        if let coordinator = coordinator, let index = childCoordinators.firstIndex(of: coordinator) {
            childCoordinators.remove(at: index)
            print("ChildCoordinators after removeChild = \(childCoordinators.count)")
        }
        
    }
}
