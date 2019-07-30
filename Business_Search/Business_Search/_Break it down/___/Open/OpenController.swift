//
//  OpenController.swift
//  Business_Search
//
//  Created by admin on 7/29/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
//import CoreData



class OpenController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchResultsUpdating {
    var coordinator         : SearchTableCoordinator?
    var businessViewModel   : BusinessViewModel!
    var categoryViewModel   : CategoryViewModel!
    var viewObject          : OpenView!
    var dataController      : DataController!
    var latitude            : Double!
    var longitude           : Double!
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CategoryCell.self, forCellReuseIdentifier: categoryCellID)
        tableView.register(BusinessCell.self, forCellReuseIdentifier: businessCellID)
        tableView.dataSource        = self
        tableView.delegate          = self
        tableView.separatorColor    = UIColor.clear
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        businessViewModel.fetchBusinessController           = nil
        categoryViewModel.fetchCategoryNames  = nil
        navigationItem.searchController                     = searchController
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Pause", style: .done, target: self, action: #selector(handleRightBarButton))
        view.addSubview(tableView)
        tableView.fillSafeSuperView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {return .lightContent}
    @objc func handleRightBarButton(){print("")}
    
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return businessViewModel.fetchBusinessController?.fetchedObjects?.count ?? 0
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: businessCellID, for: indexPath) as! BusinessCell
//        guard let business = businessViewModel.fetchBusinessController?.object(at: indexPath) else {return UITableViewCell()}
//        cell.firstViewModel = BusinessCellViewModel(business: business,colorIndex: indexPath)
//        return cell
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryViewModel.fetchCategoryNames?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: categoryCellID, for: indexPath) as! CategoryCell
        guard let currentCategoryName = categoryViewModel.fetchCategoryNames?[indexPath.row] else {
            return UITableViewCell()
        }
        cell.firstViewModel = CategoryCellViewModel(name: currentCategoryName, colorIndex: indexPath, latitude: latitude, longitude: longitude, dataController: dataController)
        return cell
    }
    
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
}




extension OpenController {
    func updateSearchResults(for searchController: UISearchController) {
        //Text typed into Search Bar
        if searchBarIsEmpty() {
            resetAllFetchControllers()
            return
        }
        guard let searchString = searchController.searchBar.text else {return}
        updateBusinessPredicate(searchString: searchString)
        //tableDataSource.updateCategoryArrayNamesPredicate(searchString: searchString)
        reloadFetchControllers()
        tableView.reloadData()
    }
    
    func resetAllFetchControllers() {
        resetAllControllerAndPredicates()
        DispatchQueue.main.async {self.tableView.reloadData()}
    }
    
    func resetAllControllerAndPredicates() {
        businessViewModel.fetchBusinessPredicate = nil
        categoryViewModel.fetchCategoryArrayNamesPredicate = nil
        //        fetchBusinessController = nil
        //        fetchCategoryNames = nil
        //        fetchFavoritePredicate = nil
        //        fetchFavoritesController = nil
    }
    
    func searchBarIsEmpty() -> Bool {return searchController.searchBar.text?.isEmpty ?? true}
    func reloadFetchControllers(){businessViewModel.fetchBusinessController = nil}
    func updateBusinessPredicate(searchString: String){
        businessViewModel.fetchBusinessPredicate = NSPredicate(format: "name CONTAINS[cd] %@", argumentArray: [searchString])
        //        fetchCategoryNames = nil
    }
}


