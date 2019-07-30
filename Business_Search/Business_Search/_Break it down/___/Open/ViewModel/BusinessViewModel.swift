//
//  OpenViewModel.swift
//  Business_Search
//
//  Created by admin on 7/29/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import CoreData

struct BusinessViewModel {
    var dataController: DataController!
    var latitude: Double!
    var longitude: Double!
    
    lazy var predicateBusinessLatitude  = NSPredicate(format: "%K == %@", argumentArray: [#keyPath(Business.parentLocation.latitude), latitude!])
    lazy var predicateBusinessLongitude = NSPredicate(format: "%K == %@", argumentArray: [#keyPath(Business.parentLocation.longitude), longitude!])
    
    
    var fetchBusinessPredicate : NSPredicate? {
        didSet {
            NSFetchedResultsController<NSFetchRequestResult>.deleteCache(withName: nil) //Just in case
            fetchBusinessController?.fetchRequest.predicate = fetchBusinessPredicate
        }
    }
    
    var fetchBusinessController: NSFetchedResultsController<Business>? { //+1
        didSet {    //+2
            if fetchBusinessController == nil { //+3
                fetchBusinessController = {   //+4
                    let fetchRequest: NSFetchRequest<Business> = Business.fetchRequest()
                    
                    var predicate: [NSPredicate] = [predicateBusinessLatitude, predicateBusinessLongitude]
                    if let _predicate = fetchBusinessPredicate { predicate.append(_predicate)}
                    let openingControllerPredicate =  NSCompoundPredicate(andPredicateWithSubpredicates: predicate)
                    var filterControllerPredicate = UserAppliedFilter.shared.getBusinessPredicate()
                    filterControllerPredicate.append(openingControllerPredicate)
                    
                    fetchRequest.predicate = NSCompoundPredicate(type: .and, subpredicates: filterControllerPredicate)
                    
                    let sortDescriptor = NSSortDescriptor(keyPath: \Business.name, ascending: true)
                    let sortDescriptor2 = NSSortDescriptor(keyPath: \Business.isFavorite, ascending: false)
                    fetchRequest.sortDescriptors = [sortDescriptor2, sortDescriptor]
                    let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                               managedObjectContext: dataController.viewContext,
                                                                               sectionNameKeyPath: nil,
                                                                               cacheName: nil)
                    do {
                        print("Performing Business Fetch with: \n   \(fetchRequest.predicate!)")
                        try aFetchedResultsController.performFetch()
                    } catch let error {
                        fatalError("Unresolved error \(error)")
                    }
                    return aFetchedResultsController
                }() //-4
            }   //-3
        }   //-2
    }   //-1
}
