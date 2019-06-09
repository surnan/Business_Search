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
    func updateSearchResults(for searchController: UISearchController) {
        //        if searchBarIsEmpty() {
        //            reloadResetFetchControllers()
        //            return
        //        }
        //        fetchBusinessPredicate = NSPredicate(format: "name CONTAINS[cd] %@", argumentArray: [searchController.searchBar.text!])
        //        fetchCategoryArrayNamesPredicate = NSPredicate(format: "title CONTAINS[cd] %@", argumentArray: [searchController.searchBar.text!])
        //        reloadFetchControllers()
    }
    
    var dataController: DataController!                        //MARK: Injected
    var businessID: String?
    
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
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchFavoritesController?.fetchedObjects?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell2 = tableView.dequeueReusableCell(withIdentifier: favoriteBusinessCellID, for: indexPath) as! FavoriteBusinessCell
        cell2.backgroundColor = colorArray[indexPath.row % colorArray.count]
        cell2.favoriteBusiness = fetchFavoritesController?.object(at: indexPath)
        return cell2
    }
    
    func setupNavigationMenu(){
        navigationItem.title = "FAVORITES"
        //Delete all needs to update isFavorite core data attribute on business
        //FavoriteBusiness & Business should have same ID since it's blindly copied over during FavoriteBusiness creation
        //navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete All", style: .done, target: self, action: #selector(...))
    }
    
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print("Row selected @ \(indexPath)")
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let rowAction = UITableViewRowAction(style: .normal, title: "Delete") { (action, indexPath) in
            let currentBusiness = self.fetchFavoritesController?.object(at: indexPath)
            self.deleteFavorite(currentFavorite: currentBusiness!, indexPath: indexPath)
        }
        return [rowAction]
    }
    
    
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
            fetchFavoritesController = nil
            self.tableView.reloadData()
        } catch {
            print("Failed to save the deletion of favorite - short: \n\(error.localizedDescription)")
            print("Failed to save the deletion of favorite - long: \n\(error)")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        [tableView].forEach{view.addSubview($0)}
        tableView.fillSafeSuperView()
        fetchFavoritesController = nil
        setupNavigationMenu()
    }
}
