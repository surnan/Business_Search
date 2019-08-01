//
//  OpenCoordinator.swift
//  Business_Search
//
//  Created by admin on 7/21/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import MapKit

class OpenCoordinator: Coordinator, SettingsType, BusinessDetailsType, FilterType, TabControllerType {
    private let dataController  : DataController
    private var location        : CLLocation
    var getLatitude             : Double {return location.coordinate.latitude}
    var getLongitude            : Double {return location.coordinate.longitude}
    
    init(dataController: DataController, router: RouterType, location: CLLocation){
        self.dataController = dataController
        self.location       = location
        super.init(router: router)
    }
    
    func updateCoordinate(latitude: Double, longitude: Double){
        location = CLLocation(latitude: latitude, longitude: longitude)
    }
    
    func start(parent: Coordinator){
        let newController       = OpenController(lat: getLatitude, lon: getLongitude)
        let businessViewModel   = BusinessViewModel(delegate: newController, dataController: dataController)
        let categoryViewModel   = CategoryCountViewModel(delegate: newController, dataController: dataController)
        let favoritesViewModel  = FavoritesViewModel(dataController: dataController)
        let locationViewModel   = LocationViewModel(latitude: getLatitude, longitude: getLongitude, dataController: dataController)
        let viewObject          = OpenView()
        
        viewObject.viewModel    = businessViewModel
        
        newController.businessViewModel     = businessViewModel
        newController.categoryCountViewModel = categoryViewModel
        newController.favoritesViewModel    = favoritesViewModel
        newController.locationViewModel     = locationViewModel
        newController.viewObject            = viewObject
        newController.dataController        = dataController
        newController.coordinator           = self
        
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

