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
    
    
    init(businesses: [Business], categoryName: String, router: RouterType) {
        self.businesses     = businesses
        self.categoryName   = categoryName
        super.init(router: router)
    }
    
    func start(parent: Coordinator) {
        let vc = GroupsController()
        vc.businesses   = businesses
        vc.categoryName = categoryName
        router.push(router, animated: true){[weak self, weak parent] in
            parent?.removeChild(self)
            print("-2 popped -2")
        }
    }
}
