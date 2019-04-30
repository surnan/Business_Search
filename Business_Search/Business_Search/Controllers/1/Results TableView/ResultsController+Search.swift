//
//  ResultsController+Search.swift
//  Business_Search
//
//  Created by admin on 4/18/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData

extension ResultsController {
//    func setupFetchController(){
//        let fetchRequest: NSFetchRequest<Business> = Business.fetchRequest()
//        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
//        myFetchController = NSFetchedResultsController(fetchRequest: fetchRequest,
//                                                       managedObjectContext: dataController.viewContext,
//                                                       sectionNameKeyPath: nil,
//                                                       cacheName: nil)
//        do {
//            try myFetchController.performFetch()
//        } catch {
//            fatalError("Unable to setup Fetch Controller: \n\(error)")
//        }
//    }

    func updateSearchResults(for searchController: UISearchController) {
        let fetchRequest: NSFetchRequest<Business> = Business.fetchRequest()
//        let text = "G"
        
        
//        let text = searchController.
        let predicate = NSPredicate(format: "name CONTAINS [c] %@", text)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
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
    
    
    
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        indexValue = selectedScope
        tableView.reloadData()
    }
}





























/*
//AUTO-COMPLETE - Limited to 3 results
func updateSearchResults(for searchController: UISearchController) {
    guard let text = searchController.searchBar.text else { return }
    if text.count != 0 {
        inputString = text
        // urlSessionTask?.cancel()
        // urlSessionTask = Yelp.getAutoInputResults(text: text, latitude: latitude,
        //                 longitude: longitude,
        //                 completion: handleUpdateSearchResult(result:))
        
        //Only here so I don't have to keep restarting program to get query
        print("Yelp Auto-Complete Call")
        tableView.reloadData()
    }
}
*/
