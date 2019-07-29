//
//  OpenCoordinator.swift
//  Business_Search
//
//  Created by admin on 7/21/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import MapKit

class SearchTableCoordinator: Coordinator, SettingsType, BusinessDetailsType, FilterType, TabControllerType {
    private let dataController: DataController
    private let location : CLLocation
    var getLatitude: Double {return location.coordinate.latitude}
    var getLongitude: Double {return location.coordinate.longitude}
    
    init(dataController: DataController, router: RouterType, location: CLLocation){
        self.dataController = dataController
        self.location = location
        super.init(router: router)
    }
    
    func start(parent: Coordinator){
//        let newViewModel        = SearchTableViewModel()
//        let newViewObject       = SearchTableView()
//        let newController = SearchTableController()
        
        var newViewModel  = OpenViewModel()
        let newViewObject = OpenView()
        let newController = OpenController()
        
        newViewModel.dataController = dataController
        newViewModel.latitude = getLatitude
        newViewModel.longitude = getLongitude
        
        let coordinate = location.coordinate
        newViewObject.viewModel = newViewModel
        
        newController.viewModel = newViewModel
        newController.viewObject = newViewObject
        newController.dataController = dataController
        newController.latitude = coordinate.latitude
        newController.longitude = coordinate.longitude
        newController.coordinator = self
        
        
        router.push(newController, animated: true) {[weak self, weak parent] in
            parent?.removeChild(self)
            print("-2 popped -2")
        }
    }
    
    func loadBusinessDetails(currentBusiness: Business){
        let coordinator = BusinessDetailsCoordinator(router: router, business: currentBusiness)
        addChild(coordinator)
        coordinator.start(parent: self)
    }
    
    func loadSettings(delegate: UnBlurViewProtocol, max: Int?) {
        let coordinator = SettingsCoordinator(unblurProtocol: delegate, dataController: dataController,
                                              router: router, maximumSliderValue: radius)
        coordinator.start(parent: self)
    }

    func loadFilter(unblurProtocol: UnBlurViewProtocol){
        let coordinator = FilterCoordinator(unblurProtocol: unblurProtocol, router: router)
        coordinator.start(parent: self)
    }
    
    func loadTabController(businesses: [Business], categoryName: String){
        //let coordinator = GroupsCoordinator(businesses: businesses, categoryName: categoryName, router: router)
        //let coordinator = MapsCoordinator(businesses: businesses, categoryName: categoryName, router: router)
        let coordinator = MyTabCoordinator(businesses: businesses, categoryName: categoryName, router: router)
        coordinator.start(parent: self)
    }
}
