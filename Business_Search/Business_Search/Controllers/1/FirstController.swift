//
//  FirstController.swift
//  Business_Search
//
//  Created by admin on 4/16/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

let search = UISearchController(searchResultsController: nil)


class FirstController: UIViewController, UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        // print("")
        // guard let text = searchController.searchBar.text else { return }
        // print(text)
    }
    
    func setupNavigationMenu(){
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
//        search.searchBar.placeholder = "Type something here to search"
        search.searchBar.backgroundColor = UIColor.blue
        search.searchBar.tintColor = UIColor.white //Cancel Button when you are typing
        search.searchBar.barStyle = .black      // Black background with light content
        search.searchBar.barTintColor = UIColor.orange  //Don't see it
        navigationItem.searchController = search
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
        
        
        Yelp.getAutoInputResults(text: "p", latitude: 37.786882, longitude: -122.399972) 
    }
}
