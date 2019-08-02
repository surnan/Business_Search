//
//  FavoritesViewModel.swift
//  Business_Search
//
//  Created by admin on 7/31/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import CoreData

class FavoritesViewModel {
    private var dataController: DataController
    private var fetchFavoritePredicate: NSPredicate?
    
    init(dataController: DataController) {
        self.dataController = dataController
    }
    
    //MARK:- NON-Private
    func reload(){fetchFavoritesController = nil}
    func search(id: String){fetchFavoritePredicate = NSPredicate(format: "%K == %@", argumentArray: [#keyPath(Favorites.id), id])}
    
    func search(business: Business){
        guard let id = business.id else {return}
        fetchFavoritePredicate = NSPredicate(format: "%K == %@", argumentArray: [#keyPath(Favorites.id), id])
    }
    
    func changeFavorite(business: Business)->Bool{
        do {
            business.isFavorite = !business.isFavorite
            try dataController.viewContext.save()
            return business.isFavorite
        } catch {
            print(error)
            print(error.localizedDescription)
            return business.isFavorite
        }
    }
    
    func deleteFavorite(business: Business){
        fetchFavoritesController?.fetchedObjects?.forEach({ (item) in
            dataController.viewContext.delete(item)
            do {
                try dataController.viewContext.save()
            } catch {
                print(error)
                print(error.localizedDescription)
            }
        })
    }
    
    func createFavorite(business: Business){
        let context = dataController.viewContext
        let newFavorite2 = Favorites(context: context)
        newFavorite2.id = business.id
        do {
            try context.save()
        } catch {
            print("\nError saving newly created favorite - localized error: \n\(error.localizedDescription)")
            print("\n\nError saving newly created favorite - full error: \n\(error)")
        }
    }

    var fetchFavoritesController: NSFetchedResultsController<Favorites>?{
        didSet{
            if fetchFavoritesController == nil {
                fetchFavoritesController = {
                    let fetchRequest: NSFetchRequest<Favorites> = Favorites.fetchRequest()
                    fetchRequest.predicate = fetchFavoritePredicate
                    let sortDescriptor = NSSortDescriptor(keyPath: \Favorites.id, ascending: true)
                    fetchRequest.sortDescriptors = [sortDescriptor]
                    let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                               managedObjectContext: dataController.viewContext,
                                                                               sectionNameKeyPath: nil,
                                                                               cacheName: nil)
                    do {
                        try aFetchedResultsController.performFetch()
                    } catch let error {
                        fatalError("Unresolved error \(error)")
                    }
                    return aFetchedResultsController
                }()
            }
        }
    }
}
