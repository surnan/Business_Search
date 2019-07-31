//
//  SearchByAddressCoordinator.swift
//  Business_Search
//
//  Created by admin on 7/21/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import MapKit

class SearchByAddressCoordinator: Coordinator, SearchTableType {
    private let dataController: DataController
    private let location : CLLocation
    
    init(dataController: DataController, router: RouterType, location: CLLocation){
        self.dataController = dataController
        self.location = location
        super.init(router: router)
    }
    
    func start(parent: Coordinator){
        let coor = location.coordinate
        let newViewModel = SearchByAddressViewModel(latitude: coor.latitude, longitude: coor.longitude)
        let newView = SearchByAddressView()
        newView.viewModel = newViewModel
        let newController = SearchByAddressController()
        newController.viewObject = newView
        newController.viewModel = newViewModel
        newController.coordinator = self
        router.push(newController, animated: true) {[weak self, weak parent] in
            parent?.removeChild(self)
            print("-2 popped -2")
        }
    }
    
    func loadSearchTable(location: CLLocation){
        let coordinator = OpenCoordinator(dataController: dataController, router: router, location: location)
        addChild(coordinator)
        coordinator.start(parent: self)
    }
}
