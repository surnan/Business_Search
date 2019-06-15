//
//  FavoritesController.swift
//  Business_Search
//
//  Created by admin on 6/7/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData


let favoriteBusinessCellID = "favoriteBusinessCellID"

class FavoritesController: UIViewController, NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate, UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating {

    
    var dataController: DataController!                        //MARK: Injected
    var businessID: String?
    var searchGroupIndex = 0
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(BusinessCell.self, forCellReuseIdentifier: businessCellID)
        tableView.register(CategoryCell.self, forCellReuseIdentifier: categoryCellID)
        tableView.register(_BusinessCell.self, forCellReuseIdentifier: _businessCellID)
        tableView.register(FavoriteBusinessCell.self, forCellReuseIdentifier: favoriteBusinessCellID)
        return tableView
    }()
    
    //MARK:- UI
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.scopeButtonTitles = ["Business", "Category"]
        searchController.obscuresBackgroundDuringPresentation = false
        
        //searchController.searchBar.barStyle = .black
        searchController.searchBar.tintColor = UIColor.white
        searchController.searchBar.barTintColor = UIColor.white
        searchController.searchBar.placeholder = "Enter search term ..."
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        
        //Setting background for search controller
        if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            if let backgroundview = textfield.subviews.first {
                backgroundview.backgroundColor = UIColor.white
                backgroundview.layer.cornerRadius = 10
                backgroundview.clipsToBounds = true
            }
        }
        return searchController
    }()
    
    var fetchBusinessPredicate : NSPredicate? {
        didSet {
            NSFetchedResultsController<NSFetchRequestResult>.deleteCache(withName: nil) //Just in case we use NSFetchResults Cache
            fetchBusinessController?.fetchRequest.predicate = fetchBusinessPredicate
        }
    }
    
    var fetchFavoriteBusinessPredicate : NSPredicate? {
        didSet {
            NSFetchedResultsController<NSFetchRequestResult>.deleteCache(withName: nil) //Just in case we use NSFetchResults Cache
            fetchFavoriteBusinessController?.fetchRequest.predicate = fetchBusinessPredicate
        }
    }
    
    var fetchFavoriteCategoriesPredicate: NSPredicate? {
        didSet {
            NSFetchedResultsController<NSFetchRequestResult>.deleteCache(withName: nil) //Just in case we use NSFetchResults Cache
            fetchFavoriteCategoriesController?.fetchRequest.predicate = fetchBusinessPredicate
        }
    }
    
    
    var fetchBusinessController: NSFetchedResultsController<Business>? { //+1
        didSet {    //+2
            if fetchBusinessController == nil { //+3
                fetchBusinessController = {   //+4
                    let fetchRequest: NSFetchRequest<Business> = Business.fetchRequest()
                    if let businessID = businessID {
                        fetchRequest.predicate = NSPredicate(format: "%K == %@",
                                                             argumentArray: [#keyPath(Business.id),
                                                                             businessID])
                    }
                    
                    let sortDescriptor = NSSortDescriptor(keyPath: \Business.name, ascending: true)
                    fetchRequest.sortDescriptors = [sortDescriptor]
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
    

    
    var fetchFavoriteBusinessController: NSFetchedResultsController<FavoriteBusiness>? { //+1
        didSet {    //+2
            if fetchFavoriteBusinessController == nil { //+3
                fetchFavoriteBusinessController = {   //+4
                    let fetchRequest: NSFetchRequest<FavoriteBusiness> = FavoriteBusiness.fetchRequest()
                    let sortDescriptor = NSSortDescriptor(keyPath: \FavoriteBusiness.name, ascending: true)
                    fetchRequest.sortDescriptors = [ sortDescriptor]
                    fetchRequest.predicate = fetchFavoriteBusinessPredicate
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
    

    var fetchFavoriteCategoriesController: NSFetchedResultsController<FavoriteCategory>? { //+1
        didSet {    //+2
            if fetchFavoriteCategoriesController == nil { //+3
                fetchFavoriteCategoriesController = {   //+4
                    let fetchRequest: NSFetchRequest<FavoriteCategory> = FavoriteCategory.fetchRequest()
                    if let _selectedPredicate = fetchFavoriteCategoriesPredicate {
                        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [_selectedPredicate])
                    }
                    let sortDescriptor = NSSortDescriptor(keyPath: \Category.title, ascending: true)
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
    
    
    func deleteFavorite(currentFavorite: FavoriteBusiness, indexPath: IndexPath){
        businessID = currentFavorite.id!
        print("Id passed in is: \(businessID ?? "")")
        dataController.viewContext.delete(currentFavorite)
        fetchBusinessController = nil
        guard let businessToChange = fetchBusinessController?.fetchedObjects?.first else {
            print("No business found")
            return
        }
        do {
            businessToChange.isFavorite = false
            try dataController.viewContext.save()
            fetchFavoriteBusinessController = nil
            self.tableView.reloadData()
        } catch {
            print("Failed to save the deletion of favorite - short: \n\(error.localizedDescription)")
            print("Failed to save the deletion of favorite - long: \n\(error)")
        }
    }
}
