//
//  SearchByMapCoordinator.swift
//  Business_Search
//
//  Created by admin on 7/21/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import MapKit

class SearchByMapCoordinator: Coordinator {
    let dataController: DataController
    let location : CLLocation
    
    init(dataController: DataController, router: RouterType, location: CLLocation){
        self.dataController = dataController
        self.location = location
        super.init(router: router)
    }
    
    override func start(){
        let vc = SearchByMapController()
        vc.possibleInsertLocationCoordinate = location
        vc.dataController = dataController
        router.push(vc, animated: true, completion: nil)
    }
}
