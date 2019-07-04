//
//  OpeningController+Search.swift
//  Business_Search
//
//  Created by admin on 5/1/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

extension OpeningController: UISearchResultsUpdating {
    func resetAllFetchControllers() {
        tableDataSource.resetAllControllerAndPredicates()
        model.tableView.reloadData()
    }
    
    func reloadFetchControllers() {
        tableDataSource.reloadBusinessController()
        tableDataSource.reloadCategoryNames()
        DispatchQueue.main.async {
            self.model.tableView.reloadData()
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        //Text typed into Search Bar
        if searchBarIsEmpty() {
            resetAllFetchControllers()
            return
        }
        tableDataSource.fetchBusinessPredicate = NSPredicate(format: "name CONTAINS[cd] %@", argumentArray: [searchController.searchBar.text!])
        tableDataSource.fetchCategoryArrayNamesPredicate = NSPredicate(format: "title CONTAINS[cd] %@", argumentArray: [searchController.searchBar.text!])
        reloadFetchControllers()
    }
    

    func searchBarIsEmpty() -> Bool {return searchController.searchBar.text?.isEmpty ?? true}
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {resetAllFetchControllers()}
    
    //When user clicks in searchField, Active = TRUE & If nothing is typed, return all items
    func isFiltering() -> Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!searchBarIsEmpty() || searchBarScopeIsFiltering)
    }
    
    //This is called when user switches scopes
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        tableDataSource.searchGroupIndex = selectedScope
        model.tableView.reloadData()
        ShowNothingLabelIfNoResults(group: tableDataSource.tableViewArrayType)
        animateResultsAreFilteredLabel()
    }
}
