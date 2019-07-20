//
//  Coordinators.swift
//  Business_Search
//
//  Created by admin on 7/19/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

protocol BaseCoordinatorType: class {
    func start()
}

protocol PresentableCoordinatorType: BaseCoordinatorType, Presentable {}

class PresentableCoordinator: NSObject, PresentableCoordinatorType {
    override init() {super.init()}
    open func start() {}
    open func toPresentable() -> UIViewController {fatalError("Must override toPresentable()")}
}

protocol CoordinatorType: PresentableCoordinatorType {
    var router: RouterType { get }
}

class Coordinator: PresentableCoordinator, CoordinatorType  {
    var childCoordinators: [Coordinator] = []
    var router: RouterType
    
    init(router: RouterType) {
        self.router = router
        super.init()
    }
    
    func addChild(_ coordinator: Coordinator) {childCoordinators.append(coordinator)}
    override func toPresentable() -> UIViewController {return router.toPresentable()}
    
    func removeChild(_ coordinator: Coordinator?) {
        if let coordinator = coordinator, let index = childCoordinators.firstIndex(of: coordinator) {
            childCoordinators.remove(at: index)
        }
    }
}
