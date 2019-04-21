//
//  SearchController+FetchRequest.swift
//  Business_Search
//
//  Created by admin on 4/21/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData

extension SearchController {
    
    
    func setupFetchController(){
        let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "latitude", ascending: true)]
        myFetchController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                       managedObjectContext: dataController.viewContext,
                                                       sectionNameKeyPath: nil,
                                                       cacheName: nil)
        do {
            try myFetchController.performFetch()
        } catch {
            fatalError("Unable to setup Fetch Controller: \n\(error)")
        }
    }
    
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //print("WILL CHANGE")
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //print("DID CHANGE")
        locationArray.removeAll()
        locationArray = getAllLocations()
    }
    
    
    //    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    //        switch type {
    //        case .delete:
    //            print("")
    //        case .insert:
    //            print("")
    //        case .update:
    //            print("")
    //        default:
    //            break
    //        }
    //    }
}