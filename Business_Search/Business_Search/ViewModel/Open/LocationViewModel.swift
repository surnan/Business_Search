//
//  FetchViewModel.swift
//  Business_Search
//
//  Created by admin on 7/31/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import CoreData

class LocationViewModel {
    private var dataController  : DataController
    private var latitude        : Double
    private var longitude       : Double
    private lazy var favoritesVM     = FavoritesViewModel(dataController: dataController)
    
    
    init(latitude: Double = 0, longitude: Double = 0, dataController: DataController) {
        self.latitude       = latitude
        self.longitude      = longitude
        self.dataController = dataController
    }
    
    private var fetchCategoryArrayNamesPredicate: NSPredicate? = nil

    private var predicateCategoryLatitude: NSPredicate {
      return NSPredicate(format: "%K == %@", argumentArray: [#keyPath(Location.latitude), latitude])
    }
    
    private var predicateCategoryLongitude: NSPredicate {
      return NSPredicate(format: "%K == %@", argumentArray: [#keyPath(Location.longitude), longitude])
    }
    
    //MARK:- NON-Private
    func reload(){fetchLocationController = nil}
    func getObjects() -> [Location]{return fetchLocationController?.fetchedObjects ?? []}
    
    func createLocation(data: YelpBusinessResponse, context: NSManagedObjectContext) -> (total: Int?, objectID: NSManagedObjectID?){
        let center = data.region.center
        let newLocation = Location(context: context)
        newLocation.latitude = center.latitude
        newLocation.longitude = center.longitude
        newLocation.radius = Int32(radius)
        newLocation.totalBusinesses = Int32(data.total)

        do {
            try context.save()
            return (data.total, newLocation.objectID)
        } catch {
            print("Error saving func addLocation() --\n\(error)")
            print("Localized Error saving func addLocation() --\n\(error.localizedDescription)")
            return (nil, nil)
        }
    }
    
    func deleteAllLocations(){
        let context: NSManagedObjectContext!  = dataController.backGroundContext
        context.perform {
            let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Location")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetch)
            do {
                _  = try context.execute(deleteRequest) as! NSBatchDeleteResult
                
            } catch {
                print("Error deleting All \(error)")
            }
        }
    }
    
    
    func addBusinessesAndCategories(location: Location, yelpData: YelpBusinessResponse, context: NSManagedObjectContext){
        yelpData.businesses.forEach { (item) in //+1
            let currentBusiness = Business(context: context)
            currentBusiness.parentLocation = location
            currentBusiness.alias = item.alias
            currentBusiness.displayAddress = item.location.display_address.joined(separator: "?")   //Assuming '?' isn't part of address anywhere on Yelp
            currentBusiness.displayPhone = item.display_phone
            currentBusiness.distance = item.distance!   //EXPLICIT.  Please confirm
            currentBusiness.id = item.id
            
            
            if let id = item.id, favoritesVM.isFavorite(id: id) {
                currentBusiness.isFavorite = true
            }
            
            
            currentBusiness.imageURL = item.image_url
            // currentBusiness.isClosed //NEEDS TO BE CALCULATE EVERY CALL?
            currentBusiness.latitude = item.coordinates.latitude ?? 0.0
            currentBusiness.longitude = item.coordinates.longitude ?? 0.0
            currentBusiness.name = item.name
            currentBusiness.price = item.price
            currentBusiness.rating = item.rating ?? 0
            currentBusiness.reviewCount = Int32(item.review_count ?? 0)
            currentBusiness.url = item.url

            item.categories.forEach({ (itemCategory) in
                let currentCategory = Category(context: context)
                currentCategory.alias = itemCategory.alias
                currentCategory.title = itemCategory.title
                currentCategory.business = currentBusiness
            })

            item.transactions.forEach({ (currentString) in
                if currentString.lowercased().contains("delivery") {
                    currentBusiness.isDelivery = true
                }

                if currentString.lowercased().contains("pickup") {
                    currentBusiness.isPickup = true
                }
            })

            do {
                try context.save()
            } catch {
                print("Short Error: \(error.localizedDescription)")
                print("Error saving Business to Location Entity --> func Location.addBusinesses()\n\(error)")
            }
        }
    }
    
    
    
    
    
    private var fetchLocationController: NSFetchedResultsController<Location>? {
        didSet {
            if fetchLocationController == nil {
                fetchLocationController = {
                    let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
                    let sortDescriptor = NSSortDescriptor(keyPath: \Location.latitude, ascending: true)
                    fetchRequest.sortDescriptors = [ sortDescriptor]
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
