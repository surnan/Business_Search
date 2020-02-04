//
//  ShowFavoritesCoordinator.swift
//  Business_Search
//
//  Created by admin on 11/10/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import MapKit


//   func start(parent: Coordinator){
//       let newController       = OpenController(lat: getLatitude, lon: getLongitude)
//       let businessViewModel   = BusinessViewModel(delegate: newController,
//                                                   dataController: dataController,
//                                                   gpsLocation: location)
//
//       let categoryViewModel   = CategoryCountViewModel(delegate: newController, dataController: dataController)
//       let favoritesViewModel  = FavoritesViewModel(dataController: dataController)
//       let locationViewModel   = LocationViewModel(latitude: getLatitude, longitude: getLongitude, dataController: dataController)
//       let viewObject          = OpenView()
//
//       viewObject.viewModel    = businessViewModel
//
//       newController.businessViewModel         = businessViewModel
//       newController.categoryCountViewModel    = categoryViewModel
//       newController.favoritesViewModel        = favoritesViewModel
//       newController.locationViewModel         = locationViewModel
//       newController.viewObject                = viewObject
//       newController.dataController            = dataController
//       newController.coordinator               = self
//       newController.location                  = location
//
//       router.push(newController, animated: true) {[weak self, weak parent] in
//           parent?.removeChild(self)
//           print("OpenCoordinator Popped")
//       }
//   }

class ShowFavoritesCoordinator: Coordinator {
    private let dataController: DataController
    private let location : CLLocation
    
    init(dataController: DataController, router: RouterType, location: CLLocation){
        self.dataController = dataController
        self.location = location
        
        super.init(router: router)
    }
    
    func start(parent: Coordinator){
        let newViewModel    = FavoriteBusinessViewModel(dataController: dataController, gpsLocation: location)
        let newView         = ShowFavoritesView()
        let newController   = ShowFavoritesController()
    
        newController.viewObject        = newView
        newController.viewModel         = newViewModel
        newController.coordinator       = self
        newController.currentLatitude   = location.coordinate.latitude
        newController.currentLongitude  = location.coordinate.longitude
        
        //newController.favoritesVM       = FavoritesViewModel(dataController: dataController)
        newController.favoritesVM       = FavoritesViewModel(dataController: dataController)
        newController.location          = location
         
        router.push(newController, animated: true) {[weak self, weak parent] in
            parent?.removeChild(self)
            print("ShowFavoritesCoordinator Popped")
        }
    }
}
