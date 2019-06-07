//
//  FavoritesController.swift
//  Business_Search
//
//  Created by admin on 6/7/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData


class FavoritesController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var dataController: DataController!                        //MARK: Injected
    
    
    var fetchFavoritesController: NSFetchedResultsController<FavoriteBusiness>? { //+1
        didSet {    //+2
            if fetchFavoritesController == nil { //+3
                fetchFavoritesController = {   //+4
                    let fetchRequest: NSFetchRequest<FavoriteBusiness> = FavoriteBusiness.fetchRequest()
                    let sortDescriptor = NSSortDescriptor(keyPath: \FavoriteBusiness.name, ascending: true)
                    fetchRequest.sortDescriptors = [ sortDescriptor]
                    
                    let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                               managedObjectContext: dataController.viewContext,
                                                                               sectionNameKeyPath: nil,
                                                                               cacheName: nil)
                    aFetchedResultsController.delegate = self
                    do {
                        try aFetchedResultsController.performFetch()
                    } catch let error {
                        fatalError("Unresolved error \(error)")
                    }
                    return aFetchedResultsController
                }() //-4
            }   //-3
        }   //-2
    }   //-1
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchFavoritesController?.fetchedObjects?.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = fetchFavoritesController?.object(at: indexPath).name
        return cell
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchFavoritesController = nil
    }
}
