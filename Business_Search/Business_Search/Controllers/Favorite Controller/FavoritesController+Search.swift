//
//  FavoritesController+Search.swift
//  Business_Search
//
//  Created by admin on 6/14/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData



extension FavoritesController{
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        reloadResetFetchControllers()
        print("")
    }
    
    //Text typed into Search Bar
    func updateSearchResults(for searchController: UISearchController) {
        if searchBarIsEmpty() {
            reloadResetFetchControllers()
            return
        }
        fetchBusinessPredicate = NSPredicate(format: "name CONTAINS[cd] %@", argumentArray: [searchController.searchBar.text!])
        fetchFavoriteBusinessPredicate = NSPredicate(format: "name CONTAINS[cd] %@", argumentArray: [searchController.searchBar.text!])
        fetchFavoriteCategoriesPredicate = NSPredicate(format: "title CONTAINS[cd] %@", argumentArray: [searchController.searchBar.text!])
        reloadFetchControllers()
    }
    
    func reloadResetFetchControllers() {
        fetchBusinessPredicate = nil
        fetchFavoriteBusinessPredicate = nil
        fetchFavoriteCategoriesPredicate = nil
        
        fetchBusinessController = nil
        fetchFavoriteBusinessController = nil
        fetchFavoriteCategoriesController = nil
        fetchCategoryNames = nil
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func reloadFetchControllers() {
        fetchBusinessController = nil
        fetchFavoriteBusinessController = nil
        fetchFavoriteCategoriesController = nil
        fetchCategoryNames = nil
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
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
        //ShowNothingLabelIfNoResults(group: tableViewArrayType)
        //print("SelectedSearchScope: FilterPredicate.shared.isFilterOn --> \(FilterPredicate.shared.isFilterOn)")
        //animateResultsAreFilteredLabel()
    }
}
