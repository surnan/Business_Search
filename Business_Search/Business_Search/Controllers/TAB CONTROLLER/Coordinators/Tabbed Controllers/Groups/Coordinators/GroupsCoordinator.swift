//
//  GroupsCoordinator.swift
//  Business_Search
//
//  Created by admin on 7/23/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class GroupsCoordinator: Coordinator {
    let businesses      : [Business]
    let categoryName    : String
    
    
    lazy var myGroupsController: GroupsController  = {
        let controller = GroupsController()
        controller.businesses = businesses
        controller.categoryName = categoryName
        return controller
    }()
    
    
    init(businesses: [Business], categoryName: String, router: RouterType) {
        self.businesses     = businesses
        self.categoryName   = categoryName
        super.init(router: router)
        router.setRootModule(myGroupsController, hideBar: false)
    }
}

