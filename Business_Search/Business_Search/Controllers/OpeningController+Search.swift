//
//  OpeningController+Search.swift
//  Business_Search
//
//  Created by admin on 5/1/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

extension OpeningController: UISearchResultsUpdating {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        fetchPredicate = nil
        myFetchController = nil
        tableView.reloadData()
    }

    
    //Text typed into Search Bar
    func updateSearchResults(for searchController: UISearchController) {
        if searchBarIsEmpty() {
            fetchPredicate = nil
            myFetchController = nil
            tableView.reloadData()
            return
        }
        
        print("searchController.searchBar.text! = \(searchController.searchBar.text!)")
        fetchPredicate = NSPredicate(format: "name CONTAINS [c] %@", argumentArray: [searchController.searchBar.text!])
        myFetchController = nil
        _ = myFetchController?.fetchedObjects
        tableView.reloadData()
    }
    
    //NOW IMPLEMENTS SEARCH SCOPE GROUPS
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredCandies = candies.filter({( candy : Candy) -> Bool in
            let doesCategoryMatch = (scope == "All") || (candy.category == scope)
            if searchBarIsEmpty() {
                return doesCategoryMatch
            } else {
                return doesCategoryMatch && candy.name.lowercased().contains(searchText.lowercased())
            }
        })
        tableView.reloadData()
    }
    
    // MARK: - Private instance methods
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    
    //When user clicks in searchField, Active = TRUE & If nothing is typed, return all items
    func isFiltering() -> Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!searchBarIsEmpty() || searchBarScopeIsFiltering)
    }
}

extension OpeningController {
    //This is called when user switches scopes
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        print("selectedScope --> \(selectedScope)  ... selectedScope = \(searchController.searchBar.text!)")
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}

