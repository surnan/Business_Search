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
                        fatalError("Error 0EA: Unresolved error \(error)")
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
    
    func deleteAllFavorites(){
        let context: NSManagedObjectContext!  = dataController.backGroundContext
        context.perform {
            let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetch)
            do {
                _  = try context.execute(deleteRequest) as! NSBatchDeleteResult
                
            } catch {
                print("Error 11A: Error deleting All \(error)")
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
    

    
    //MARK:- Business Entity Function Parameter
    func changeFavoriteOnBusinessEntity(business: Business)->Bool{
        do {
            business.isFavorite = !business.isFavorite
            try dataController.viewContext.save()
            return business.isFavorite
        } catch {
            print("Error 0FA: \(error)")
            print(error.localizedDescription)
            return business.isFavorite
        }
    }
    
    func createFavorite(business: Business){
        let context = dataController.viewContext
        let newFavorite2 = Favorites(context: context)
        newFavorite2.id = business.id

        ////////
        //createFavoriteBusiness(business: business, context: context)
        let showFavoritesVM = FavoriteBusinessViewModel(dataController: dataController)
        showFavoritesVM.createFavoriteBusinessAndCategories(business: business)
        ////////
        
        do {
            try context.save()
        } catch {
            print("\nError 12A: Error saving newly created favorite - localized error: \n\(error.localizedDescription)")
            print("\n\nError saving newly created favorite - full error: \n\(error)")
        }
    }

    
    func deleteFavorite(business: Business){
        fetchFavoritesController = nil
        guard let allFavorites = fetchFavoritesController?.fetchedObjects else {return}
        for (_, item) in allFavorites.enumerated(){
            if item.id == business.id {
                dataController.viewContext.delete(item)
                
                ////////
                //createFavoriteBusiness(business: business, context: context)
                let showFavoritesVM = FavoriteBusinessViewModel(dataController: dataController)
                showFavoritesVM.deleteFavoriteBusiness(business: business)
                //showFavoritesVM.createFavoriteBusinessAndCategories(business: business)
                ////////
                
                do {
                    try dataController.viewContext.save()
                } catch {
                    print("Error 10A: Error when trying to delete: \(item.id ?? "")")
                    return
                }
            }
        }
    }
    
}
