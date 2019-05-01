//
//  ResultsController+FetchRequest.swift
//  Business_Search
//
//  Created by admin on 4/30/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData

extension ResultsController: NSFetchedResultsControllerDelegate {
    func setupFetchController(){
        let fetchRequest: NSFetchRequest<Business> = Business.fetchRequest()
        let text = "the c"
        let predicate = NSPredicate(format: "name CONTAINS [c] %@", text)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        myFetchController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                       managedObjectContext: dataController.viewContext,
                                                       sectionNameKeyPath: nil,
                                                       cacheName: nil)
        myFetchController.delegate = self
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
