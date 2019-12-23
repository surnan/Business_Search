//
//  ShowFavoritesCoordinator.swift
//  Business_Search
//
//  Created by admin on 11/10/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import MapKit

class ShowFavoritesCoordinator: Coordinator {
    private let dataController: DataController
    private let location : CLLocation
    
    init(dataController: DataController, router: RouterType, location: CLLocation){
        self.dataController = dataController
        self.location = location
        super.init(router: router)
    }
    
    func start(parent: Coordinator){
        let newViewModel    = FavoriteBusinessViewModel(dataController: dataController)
        let newView         = ShowFavoritesView()
        let newController   = ShowFavoritesController()
    
        newController.viewObject        = newView
        newController.viewModel         = newViewModel
        newController.coordinator       = self
        newController.currentLatitude   = location.coordinate.latitude
        newController.currentLongitude  = location.coordinate.longitude
        newController.favoritesVM       = FavoritesViewModel(dataController: dataController)
        newController.location          = location
        
        router.push(newController, animated: true) {[weak self, weak parent] in
            parent?.removeChild(self)
            print("ShowFavoritesCoordinator Popped")
        }
    }
}
