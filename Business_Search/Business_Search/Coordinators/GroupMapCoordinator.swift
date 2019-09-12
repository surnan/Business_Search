//
//  MapCoordinate.swift
//  Business_Search
//
//  Created by admin on 7/23/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class GroupMapCoordinator: Coordinator, BusinessDetailsType, DismissType {
    let businesses      : [Business]
    let categoryName    : String
    var parent          : TabGroupCoordinator?  //because it's in a tab controller
    let dataController  : DataController
    
    lazy var myMapsController: GroupMapController = {
        let controller = GroupMapController()
        controller.businesses = businesses
        return controller
    }()

    init(dataController: DataController, businesses: [Business], categoryName: String, router: RouterType) {
        self.dataController = dataController
        self.businesses     = businesses
        self.categoryName   = categoryName
        super.init(router: router)
        router.setRootModule(myMapsController, hideBar: false)
        myMapsController.coordinator = self
        myMapsController.categoryName = categoryName
    }
    
    
    func loadBusinessDetails(currentBusiness: Business){
        let coordinator = BusinessDetailsCoordinator(dataController: dataController, router: router, business: currentBusiness)
        addChild(coordinator)
        coordinator.start(parent: self)
    }
    
    func handleDismiss(){
        parent?.dismissTabController()
    }
}
