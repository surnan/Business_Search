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
    private var myPredicate: NSPredicate?
    
    init(dataController: DataController) {
        self.dataController = dataController
    }
    
    private var fetchFavoritesController: NSFetchedResultsController<Favorites>?{
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
    
    //MARK:- NON-Private
    func reload(){fetchFavoritesController = nil}
    
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
        fetchFavoritesController = nil
        guard let allFavorites = fetchFavoritesController?.fetchedObjects else {return}
        for (_, item) in allFavorites.enumerated(){
            if item.id == business.id {
                dataController.viewContext.delete(item)
                do {
                    try dataController.viewContext.save()
                } catch {
                    print("Error when trying to delete: \(item.id ?? "")")
                    return
                }
            }
        }
    }
    
    func deleteAllFavorites(){
        let context: NSManagedObjectContext!  = dataController.backGroundContext
        context.perform {
            let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetch)
            do {
                _  = try context.execute(deleteRequest) as! NSBatchDeleteResult
                
            } catch {
                print("Error deleting All \(error)")
            }
        }
    }
    
    var idForPredicate: String?{
        didSet {
            if let id = idForPredicate {
                fetchFavoritePredicate = NSPredicate(format: "id = %@", argumentArray: [id])
            }
        }
    }
    
    func isFavorite(id: String)->Bool{
        idForPredicate = id
        fetchFavoritesController = nil
        guard let count = fetchFavoritesController?.fetchedObjects else {return false}
        return count.isEmpty ? false : true
    }
    
    func fetchedObjects() -> [Favorites]{return fetchFavoritesController?.fetchedObjects ?? []}
    
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
}
