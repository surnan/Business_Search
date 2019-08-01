//
//  OpenController+Search.swift
//  Business_Search
//
//  Created by admin on 7/30/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

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
        categoryCountViewModel.search(search: searchString)
        tableView.reloadData()
    }
    
    func resetAllFetchControllers() {
        resetAllControllerAndPredicates()
        DispatchQueue.main.async {self.tableView.reloadData()}
    }
    
    func resetAllControllerAndPredicates() {
        businessViewModel.search(search: nil)
        categoryCountViewModel.search(search: nil)
        //        businessViewModel.fetchBusinessPredicate = nil
        //        categoryViewModel.fetchCategoryArrayNamesPredicate = nil
        //        fetchBusinessController = nil
        //        fetchCategoryNames = nil
        //        fetchFavoritePredicate = nil
        //        fetchFavoritesController = nil
    }
    
    func searchBarIsEmpty() -> Bool {return searchController.searchBar.text?.isEmpty ?? true}
    
//    func reloadFetchControllers() {
//        tableDataSource.reloadBusinessController()
//        tableDataSource.reloadCategoryNames()
//        DispatchQueue.main.async {
//            self.viewObject.tableView.reloadData()
//        }
//    }
    
    func reloadFetchControllers(){
        //businessViewModel.fetchBusinessController = nil
        businessViewModel.resetController()
        categoryCountViewModel.resetController()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    //    func updateBusinessPredicate(searchString: String){
    //        businessViewModel.fetchBusinessPredicate = NSPredicate(format: "name CONTAINS[cd] %@", argumentArray: [searchString])
    //        categoryViewModel.fetchCategoryArrayNamesPredicate = NSPredicate(format: "title CONTAINS[cd] %@", argumentArray: [searchString])
//        }
}

