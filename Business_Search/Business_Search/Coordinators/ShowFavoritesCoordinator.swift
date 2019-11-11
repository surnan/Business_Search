//
//  ShowFavoritesCoordinator.swift
//  Business_Search
//
//  Created by admin on 11/10/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

class ShowFavoritesCoordinator: Coordinator {
    private let dataController: DataController
    
    init(dataController: DataController, router: RouterType){
        self.dataController = dataController
        super.init(router: router)
    }
    
    func start(parent: Coordinator){
        let newViewModel    = ShowFavoritesViewModel(dataController: dataController)
        let newView         = ShowFavoritesView()
        let newController   = ShowFavoritesController()
    
        newController.viewObject = newView
        newController.viewModel = newViewModel
        newController.coordinator = self
        newController.favoritesVM = FavoritesViewModel(dataController: dataController)
        
        router.push(newController, animated: true) {[weak self, weak parent] in
            parent?.removeChild(self)
            print("ShowFavoritesCoordinator Popped")
        }
    }
}
