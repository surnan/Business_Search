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
        resetAllPredicateRelatedVar()
        tableView.reloadData()
    }

    
    //Text typed into Search Bar
    func updateSearchResults(for searchController: UISearchController) {
        if searchBarIsEmpty() {
            resetAllPredicateRelatedVar()
            tableView.reloadData()
            return
        }
        
        fetchBusinessPredicate = NSPredicate(format: "name CONTAINS[cd] %@", argumentArray: [searchController.searchBar.text!])
        fetchCategoryPredicateForArray = NSPredicate(format: "title CONTAINS[cd] %@", argumentArray: [searchController.searchBar.text!])
        fetchBusinessController = nil   //Fetches with Predicate
        fetchCategoryNames = nil        //Fetches with Predicate
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
    
    //This is called when user switches scopes
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        print("selectedScope --> \(selectedScope)  ... selectedScope = \(searchController.searchBar.text!)")
        searchGroupIndex = selectedScope
        tableView.reloadData()
        ShowNothingLabelIfNoResults(group: tableViewArrayType)
    }
}
