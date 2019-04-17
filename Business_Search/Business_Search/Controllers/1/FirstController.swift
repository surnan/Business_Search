//
//  FirstController.swift
//  Business_Search
//
//  Created by admin on 4/16/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit




class FirstController: UIViewController, UISearchControllerDelegate{
    let resultsTableController = ResultsTableViewController()
    //var resultsTableController: ResultsTableViewController? //Can't make it work
    
    lazy var searchController: UISearchController = {
        var search = UISearchController(searchResultsController: resultsTableController)
        search.delegate = self
        search.searchResultsUpdater = resultsTableController
        search.searchBar.delegate = resultsTableController
        search.searchBar.placeholder = "Search place"
        search.searchBar.barTintColor = navigationController?.navigationBar.barTintColor
        search.searchBar.tintColor = self.view.tintColor
        search.searchBar.scopeButtonTitles = ["Business Names", "Categories"]
        search.searchBar.barStyle = .black      // Typing Font = white
        //        search.obscuresBackgroundDuringPresentation = true
        
        //DON'T SEE IT
        //        search.searchBar.sizeToFit()
        //        search.dimsBackgroundDuringPresentation = true
        //        search.loadViewIfNeeded()
        //        search.hidesNavigationBarDuringPresentation = false
        //        search.searchBar.barTintColor = UIColor.orange
        return search
    }()
    
    
    func updateSearchResults(for searchController: UISearchController) {
//         guard let text = searchController.searchBar.text else { return }
//        _ = Yelp.getAutoInputResults(text: text, latitude: 37.786882, longitude: -122.399972)
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        print("New scope index is now \(selectedScope)")
    }
    
    func setupNavigationMenu(){
        navigationItem.searchController = searchController
        navigationItem.title = "Business Search"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Left", style: .done, target: self, action: #selector(sayHello))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Right", style: .done, target: self, action: #selector(sayHello))
    }
    
    
    @objc func sayHello(){
        print("Hello")
    }
    
    

    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.white
        setupNavigationMenu()
        definesPresentationContext = true //Keeps the navigation & search menu on screen and forces tableView underneath
        // _ = Yelp.getAutoInputResults(text: "p", latitude: 37.786882, longitude: -122.399972)
    }
}
