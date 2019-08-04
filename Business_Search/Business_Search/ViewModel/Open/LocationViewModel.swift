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
    
    init(latitude: Double, longitude: Double, dataController: DataController) {
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
            
        do {
            try context.save()
            return (data.total, newLocation.objectID)
        } catch {
            print("Error saving func addLocation() --\n\(error)")
            print("Localized Error saving func addLocation() --\n\(error.localizedDescription)")
            return (nil, nil)
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
