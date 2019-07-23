//
//  MapCoordinate.swift
//  Business_Search
//
//  Created by admin on 7/23/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class MapsCoordinator: Coordinator {
    let businesses      : [Business]
    let categoryName    : String
    
    
    lazy var myMapsController: MapController = {
        let controller = MapController()
        controller.businesses = businesses
        return controller
    }()

    init(businesses: [Business], categoryName: String, router: RouterType) {
        self.businesses     = businesses
        self.categoryName   = categoryName
        super.init(router: router)
        router.setRootModule(myMapsController, hideBar: false)
    }
}



//class MapsCoordinator: Coordinator {
//    let businesses      : [Business]
//    let categoryName    : String
//
//    init(businesses: [Business], categoryName: String, router: RouterType) {
//        self.businesses     = businesses
//        self.categoryName   = categoryName
//        super.init(router: router)
//    }
//
//    func start(parent: Coordinator) {
//        let vc = MapController()
//        vc.businesses   = businesses
//        //vc.categoryName = categoryName
//        vc.coordinator = self
//        router.push(vc, animated: true){[weak self, weak parent] in
//            parent?.removeChild(self)
//            print("-2 popped -2")}
//    }
//}
