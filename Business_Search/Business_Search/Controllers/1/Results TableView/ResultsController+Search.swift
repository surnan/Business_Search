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
    func updateSearchResults(for searchController: UISearchController) {
        let fetchRequest: NSFetchRequest<Business> = Business.fetchRequest()
        
        myFetchController = nil
        tableView.reloadData()
        
        NSFetchedResultsController<NSFetchRequestResult>.deleteCache(withName: nil)
        
        guard let text = searchController.searchBar.text else { return }
        if text.isEmpty {return}
        
        
        let predicate = NSPredicate(format: "name BEGINSWITH [c] %@", text)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        myFetchController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                       managedObjectContext: dataController.viewContext,
                                                       sectionNameKeyPath: nil,
                                                       cacheName: nil)
        do {
            try myFetchController.performFetch()
        
            //  ForEach Loop prints the correct values from executing fetch with new predicate
            let fetchedObjects = myFetchController.fetchedObjects
            fetchedObjects?.forEach{
                print("temp = \($0.name ?? "")")
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        } catch {
            fatalError("Unable to setup Fetch Controller: \n\(error)")
        }
    }
    
    
    //    var indexValue = 0
    //    var inputString = ""
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
//        indexValue = selectedScope
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
