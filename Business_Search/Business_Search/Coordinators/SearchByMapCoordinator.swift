//
//  SearchByMapCoordinator.swift
//  Business_Search
//
//  Created by admin on 7/21/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import MapKit


class SearchByMapCoordinator: Coordinator, BarButtonToOpeningType {
    let dataController: DataController
    let location : CLLocation
    
    init(dataController: DataController, router: RouterType, location: CLLocation){
        self.dataController = dataController
        self.location = location
        super.init(router: router)
    }
    
   func start(parent: Coordinator){
        let vc = SearchByMapController()
        vc.possibleInsertLocationCoordinate = location
        vc.dataController = dataController
        vc.coordinator  = self
        router.push(vc, animated: true){[weak self, weak parent] in
            parent?.removeChild(self)
            print("-2 popped -2")
        }
    }
    
    func handleNext(dataController: DataController, location: CLLocation){
        let coordinator = OpenCoordinator(dataController: dataController, router: router, location: location)
        addChild(coordinator)
        coordinator.start(parent: self)
    }
}

