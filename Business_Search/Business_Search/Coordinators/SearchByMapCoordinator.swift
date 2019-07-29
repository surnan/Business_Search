//
//  SearchByMapCoordinator.swift
//  Business_Search
//
//  Created by admin on 7/21/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import MapKit

class SearchByMapCoordinator: Coordinator, SearchTableType {
    private let dataController: DataController
    private let location : CLLocation
    
    init(dataController: DataController, router: RouterType, location: CLLocation){
        self.dataController = dataController
        self.location = location
        super.init(router: router)
    }
    
    func start(parent: Coordinator){
        let coor = location.coordinate
        let newViewModel = SearchByMapViewModel(latitude: coor.latitude, longitude: coor.longitude)
        let newViewObject = SearchByMapView()
        
        newViewObject.viewModel = newViewModel
        
        let newController = SearchByMapController()
        newController.viewObject = newViewObject
        newController.viewModel = newViewModel
        newController.coordinator  = self
        router.push(newController, animated: true){[weak self, weak parent] in
            parent?.removeChild(self)
            print("-2 popped -2")
        }
    }
    
    func loadSearchTable(location: CLLocation){
        let coordinator = SearchTableCoordinator(dataController: dataController, router: router, location: location)
        addChild(coordinator)
        coordinator.start(parent: self)
    }
}

