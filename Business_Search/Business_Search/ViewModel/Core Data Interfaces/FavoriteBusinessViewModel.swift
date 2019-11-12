//
//  ShowFavoritesViewModel.swift
//  Business_Search
//
//  Created by admin on 11/10/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import CoreData

class FavoriteBusinessViewModel {
    private var dataController: DataController
    private var business: Business?
    
    init(dataController: DataController, business: Business? = nil) {
        self.dataController = dataController
        self.business = business
    }
    
    private var fetchPredicateBusinessID: NSPredicate? {
        guard let business = business, let id = business.id else {return nil}
        return NSPredicate(format: "%K == %@", argumentArray: [#keyPath(FavoriteBusiness.id), id])
    }
    
    
    func reload(){
        fetchShowFavoritesController = nil
    }
    
    private var fetchShowFavoritesController: NSFetchedResultsController<FavoriteBusiness>?{
        didSet{
            if fetchShowFavoritesController == nil {
                fetchShowFavoritesController = {
                    let fetchRequest: NSFetchRequest<FavoriteBusiness> = FavoriteBusiness.fetchRequest()
                    if let fetchPredicateBusinessID = fetchPredicateBusinessID {
                        fetchRequest.predicate = fetchPredicateBusinessID
                    }
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
    
    
    //func createFavoriteBusinessAndCategories(business: Business, context: NSManagedObjectContext){
    func createFavoriteBusinessAndCategories(business: Business){
        let context = dataController.viewContext
        let favoriteBusiness = FavoriteBusiness(context: context)
        
        favoriteBusiness.url         = business.url
        favoriteBusiness.reviewCount = business.reviewCount
        favoriteBusiness.rating      = business.rating
        favoriteBusiness.price       = business.price
        favoriteBusiness.name        = business.name
        favoriteBusiness.longitude   = business.longitude
        favoriteBusiness.latitude    = business.latitude
        favoriteBusiness.isPickup    = business.isPickup
        favoriteBusiness.isFavorite  = business.isFavorite
        favoriteBusiness.isDelivery  = business.isDelivery
        favoriteBusiness.imageURL    = business.imageURL
        favoriteBusiness.id          = business.id
        favoriteBusiness.distance    = business.distance
        favoriteBusiness.alias       = business.alias
        favoriteBusiness.displayPhone   = business.displayPhone
        favoriteBusiness.displayAddress = business.displayAddress
        
        business.categories?.forEach({ (currentItem) in
            if let currentCategoryItem = currentItem as? Category {
                let favoriteCategory = FavoriteCategory(context: context)
                favoriteCategory.alias = currentCategoryItem.alias
                favoriteCategory.title = currentCategoryItem.title
                favoriteCategory.favoriteBusiness = favoriteBusiness
                do {
                    try context.save()
                } catch {
                    print("Error 15A: Short Error: \(error.localizedDescription)")
                    print("Error saving, creating 'createFavoriteBusinessAndCategories' --> func createFavoriteBusinessAndCategories()\n\(error)")
                }
            }
            
//            do {
//                try context.save()
//            } catch {
//                print("Error ZZZ: on catch")
//            }
        })
        
        do {
            try context.save()
        } catch {
            print("Error 14A: Short Error: \(error.localizedDescription)")
            print("Error saving, creating 'createFavoriteBusinessAndCategories' --> func createFavoriteBusinessAndCategories()\n\(error)")
        }
    }
    
    func objectAt(indexPath: IndexPath)-> FavoriteBusiness? {return fetchShowFavoritesController?.object(at: indexPath)} //It's OK for forced-unwrap because it has to exist at this stage   //Sometimes objectAt returns NIL
    
    func fetchedObjects() -> [FavoriteBusiness]{return fetchShowFavoritesController!.fetchedObjects ?? []}
    
    func deleteFavoriteBusiness(business: Business){
        self.business = business
        fetchShowFavoritesController = nil
        guard let fetchController = fetchShowFavoritesController,
            let allObjects = fetchController.fetchedObjects,
            let itemToDelete = allObjects.first else {return}
        
        dataController.viewContext.delete(itemToDelete)
        
        do {
            try dataController.viewContext.save()
        } catch {
            print("Error 15A: Short Error: \(error.localizedDescription)")
            print("Error deleting, 'deleteFavoriteBusiness' --> func deleteFavoriteBusiness()\n\(error)")
        }
    }
    
    func deleteAllFavorites(){
        let context: NSManagedObjectContext!  = dataController.backGroundContext
        context.perform {
            let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteBusiness")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetch)
            do {
                _  = try context.execute(deleteRequest) as! NSBatchDeleteResult
                
            } catch {
                print("Error 11A: Error deleting All \(error)")
            }
        }
        

        
    }
}
