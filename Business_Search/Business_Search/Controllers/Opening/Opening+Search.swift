//
//  OpeningController+Search.swift
//  Business_Search
//
//  Created by admin on 5/1/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

extension SearchTableController: UISearchResultsUpdating {
    func resetAllFetchControllers() {
        tableDataSource.resetAllControllerAndPredicates()
        DispatchQueue.main.async {
            self.model.tableView.reloadData()
        }
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
        guard let searchString = searchController.searchBar.text else {return}
        tableDataSource.updateBusinessPredicate(searchString: searchString)
        tableDataSource.updateCategoryArrayNamesPredicate(searchString: searchString)
        reloadFetchControllers()
        model.tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        //This is called when user switches scopes
        tableDataSource.searchGroupIndex = selectedScope
        model.tableView.reloadData()
        ShowNothingLabelIfNoResults(group: tableDataSource.tableViewArrayType)
        animateResultsAreFilteredLabel()
    }

    func isFiltering() -> Bool {
        //When user clicks in searchField, Active = TRUE & If nothing is typed, return all items
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!searchBarIsEmpty() || searchBarScopeIsFiltering)
    }
    
    func searchBarIsEmpty() -> Bool {return searchController.searchBar.text?.isEmpty ?? true}
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {resetAllFetchControllers()}
}
