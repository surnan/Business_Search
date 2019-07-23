//
//  OpenCoordinator.swift
//  Business_Search
//
//  Created by admin on 7/21/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import MapKit

class OpeningCoordinator: Coordinator, SettingsType, BusinessDetailsType, FilterType, TabControllerType {
    let dataController: DataController
    let location : CLLocation
    
    init(dataController: DataController, router: RouterType, location: CLLocation){
        self.dataController = dataController
        self.location = location
        super.init(router: router)
    }
    
    func start(parent: Coordinator){
        let coordinate = location.coordinate
        let vc = OpeningController()
        vc.dataController = dataController
        vc.latitude = coordinate.latitude
        vc.longitude = coordinate.longitude
        vc.coordinator = self
        router.push(vc, animated: true) {[weak self, weak parent] in
            parent?.removeChild(self)
            print("-2 popped -2")
        }
    }
    
    func handleBusinessDetails(currentBusiness: Business){
        let coordinator = BusinessDetailsCoordinator(router: router, business: currentBusiness)
        addChild(coordinator)
        coordinator.start(parent: self)
    }
    
    func handleSettings(dataController: DataController, delegate: UnBlurViewProtocol, max: Int?) {
        let coordinator = SettingsCoordinator(unblurProtocol: delegate, dataController: dataController, router: router, maximumSliderValue: radius)
        coordinator.start(parent: self)
    }

    func handleFilter(unblurProtocol: UnBlurViewProtocol){
        let coordinator = FilterCoordinator(unblurProtocol: unblurProtocol, router: router)
        coordinator.start(parent: self)
    }
    
    func handleTabController(businesses: [Business], categoryName: String){
        let coordinator = GroupsCoordinator(businesses: businesses, categoryName: categoryName, router: router)
        coordinator.start(parent: self)
    }
}
