//
//  PresentableCoordinator.swift
//  Business_Search
//
//  Created by admin on 8/1/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class PresentableType: NSObject, PresentableCoordinatorType {
    override init() {super.init()}
    open func start() {}
    open func toPresentable() -> UIViewController {fatalError("Must override toPresentable()")}
}
