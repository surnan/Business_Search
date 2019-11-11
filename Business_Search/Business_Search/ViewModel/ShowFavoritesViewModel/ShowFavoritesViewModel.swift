//
//  ShowFavoritesViewModel.swift
//  Business_Search
//
//  Created by admin on 11/10/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import CoreData

//let coor = location.coordinate
//let newViewModel = SearchByAddressViewModel(latitude: coor.latitude, longitude: coor.longitude)
//let newView = SearchByAddressView()
//newView.viewModel = newViewModel
//let newController = SearchByAddressController()
//newController.viewObject = newView
//newController.viewModel = newViewModel
//newController.coordinator = self


class ShowFavoritesViewModel {
    private var dataController: DataController
    
    init(dataController: DataController) {
        self.dataController = dataController
    }
    
    
    private var fetchShowFavoritesController: NSFetchedResultsController<FavoriteBusiness>?{
        didSet{
            if fetchShowFavoritesController == nil {
                fetchShowFavoritesController = {
                    let fetchRequest: NSFetchRequest<FavoriteBusiness> = FavoriteBusiness.fetchRequest()
                    //fetchRequest.predicate = fetchFavoritePredicate
                    let sortDescriptor = NSSortDescriptor(keyPath: \Favorites.id, ascending: true)
                    fetchRequest.sortDescriptors = [sortDescriptor]
                    let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                               managedObjectContext: dataController.viewContext,
                                                                               sectionNameKeyPath: nil,
                                                                               cacheName: nil)
                    do {
                        try aFetchedResultsController.performFetch()
                    } catch let error {
                        fatalError("Error 0EA: Unresolved error \(error)")
                    }
                    return aFetchedResultsController
                }()
            }
        }
    }
    
    
    
    
    func createFavoriteBusiness(business: Business){
        let context = dataController.viewContext
        
    }
    
    func deleteFavoriteBusiness(business: Business){
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}
