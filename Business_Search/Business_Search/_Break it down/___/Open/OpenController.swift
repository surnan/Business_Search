//
//  OpenController.swift
//  Business_Search
//
//  Created by admin on 7/29/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

//class OpenController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchResultsUpdating {
class OpenController: UIViewController, UITableViewDelegate, UISearchBarDelegate, UISearchResultsUpdating, DataSourceParent {
    var coordinator         : SearchTableCoordinator?
    var businessViewModel   : BusinessViewModel!
    var categoryViewModel   : CategoryViewModel!
    var viewObject          : OpenView!
    var dataController      : DataController!
    var latitude            : Double!
    var longitude           : Double!
    
    
    var searchGroupIndex    = 0
    var tableViewArrayType  : Int { return searchGroupIndex }
    enum TableIndex         : Int { case business = 0, category }
    

    lazy var tableDataSource = Open_DataSource(parent: self)
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CategoryCell.self, forCellReuseIdentifier: categoryCellID)
        tableView.register(BusinessCell.self, forCellReuseIdentifier: businessCellID)
        tableView.delegate          = self
        tableView.separatorColor    = UIColor.clear
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = tableDataSource
        businessViewModel.fetchBusinessController   = nil
        categoryViewModel.fetchCategoryNames        = nil
        navigationItem.searchController             = searchController
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Pause", style: .done, target: self, action: #selector(handleRightBarButton))
        view.addSubview(tableView)
        tableView.fillSafeSuperView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {return .lightContent}
    @objc func handleRightBarButton(){print("")}

    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.scopeButtonTitles = ["Business", "Category"]
        searchController.obscuresBackgroundDuringPresentation = false
        //searchController.searchBar.barStyle = .black
        searchController.searchBar.tintColor    = UIColor.white
        searchController.searchBar.barTintColor = UIColor.white
        searchController.searchBar.placeholder  = "Enter search term ..."
        searchController.searchBar.delegate     = self
        searchController.searchResultsUpdater   = self
        //Setting background for search controller
        if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            if let backgroundview = textfield.subviews.first {
                backgroundview.backgroundColor      = UIColor.white
                backgroundview.layer.cornerRadius   = 10
                backgroundview.clipsToBounds = true
            }
        }
        return searchController
    }()
}


extension OpenController {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        //This is called when user switches scopes
        searchGroupIndex = selectedScope
        tableView.reloadData()
        //        ShowNothingLabelIfNoResults(group: tableDataSource.tableViewArrayType)
        //        animateResultsAreFilteredLabel()
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        //Text typed into Search Bar
        if searchBarIsEmpty() {
            resetAllFetchControllers()
            return
        }
        guard let searchString = searchController.searchBar.text else {return}
        businessViewModel.search(search: searchString)
        categoryViewModel.search(search: searchString)
        tableView.reloadData()
    }
    
    func resetAllFetchControllers() {
        resetAllControllerAndPredicates()
        DispatchQueue.main.async {self.tableView.reloadData()}
    }
    
    func resetAllControllerAndPredicates() {
        businessViewModel.search(search: nil)
        categoryViewModel.search(search: nil)
        //        businessViewModel.fetchBusinessPredicate = nil
        //        categoryViewModel.fetchCategoryArrayNamesPredicate = nil
        //        fetchBusinessController = nil
        //        fetchCategoryNames = nil
        //        fetchFavoritePredicate = nil
        //        fetchFavoritesController = nil
    }
    
    func searchBarIsEmpty() -> Bool {return searchController.searchBar.text?.isEmpty ?? true}
    func reloadFetchControllers(){businessViewModel.fetchBusinessController = nil}
    //    func updateBusinessPredicate(searchString: String){
    //        businessViewModel.fetchBusinessPredicate = NSPredicate(format: "name CONTAINS[cd] %@", argumentArray: [searchString])
    //        categoryViewModel.fetchCategoryArrayNamesPredicate = NSPredicate(format: "title CONTAINS[cd] %@", argumentArray: [searchString])
    //    }
}


