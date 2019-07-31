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
    private let dataController  : DataController
    private let location        : CLLocation
    var getLatitude             : Double {return location.coordinate.latitude}
    var getLongitude            : Double {return location.coordinate.longitude}
    
    init(dataController: DataController, router: RouterType, location: CLLocation){
        self.dataController = dataController
        self.location       = location
        super.init(router: router)
    }                     
    
    func start(parent: Coordinator){
        let newBusinessViewModel    = BusinessViewModel(dataController: dataController, lat: getLatitude, lon: getLongitude) //1
        let newCategoryViewModel    = CategoryNameCountViewModel(dataController: dataController, lat: getLatitude, lon: getLongitude) //2
        
        
        let newViewObject           = OpenView()
        let newController           = OpenController()
        
        newViewObject.viewModel         = newBusinessViewModel
        
        newController.businessViewModel = newBusinessViewModel  //1
        newController.categoryViewModel = newCategoryViewModel  //2
        
        newController.viewObject        = newViewObject
        newController.dataController    = dataController
        newController.latitude          = getLatitude
        newController.longitude         = getLongitude
        newController.coordinator       = self
        
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
        let coordinator = MyTabCoordinator(businesses: businesses, categoryName: categoryName, router: router)
        coordinator.start(parent: self)
    }
    
    func shareItems(items: [Any]){
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        activityVC.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if !completed {
                return
            }
            activityVC.dismiss(animated: true, completion: {[weak self] in
                self?.router.dismissModule(animated: true, completion: nil)
            })
        }
        router.present(activityVC, animated: true)
    }
}













//        func _start(parent: Coordinator){
//            let newViewModel        = SearchTableViewModel()
//            let newViewObject       = SearchTableView()
//
//            newViewObject.viewModel = newViewModel
//            let coordinate = location.coordinate
//            let newController = SearchTableController()
//            newController.dataController = dataController
//            newController.latitude = coordinate.latitude
//            newController.longitude = coordinate.longitude
//            newController.coordinator = self
//            newController.viewObject               = newViewObject
//            newController.viewModel                = newViewModel
//            router.push(newController, animated: true) {[weak self, weak parent] in
//                parent?.removeChild(self)
//                print("-2 popped -2")
//            }
//        }
