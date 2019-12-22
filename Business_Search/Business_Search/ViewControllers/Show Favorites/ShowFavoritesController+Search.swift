//
//  ShowFavoritesController+Search.swift
//  Business_Search
//
//  Created by admin on 12/4/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

extension ShowFavoritesController {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //tempStringForSearchField = searchBar.text ?? ""
    }
    
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        //This is called when user switches scopes
        //searchGroupIndex = selectedScope
        //tableView.reloadData()
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //        if searchText == "" {
        //            resetAllControllerAndPredicates()
        //            tableView.reloadData()
        //        }
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        //        //Text typed into Search Bar
        //        if searchBarIsEmpty() {
        //            resetAllFetchControllers()
        //            return
        //        }
        //        guard let searchString = searchController.searchBar.text else {return}
        //        businessViewModel.search(search: searchString)
        //        categoryCountViewModel.search(search: searchString)
        //        tableView.reloadData()
    }
    
    func resetAllFetchControllers() {
        //        resetAllControllerAndPredicates()
        //        DispatchQueue.main.async {self.tableView.reloadData()}
    }
    
    func resetAllControllerAndPredicates() {
        //        categoryCountViewModel.reload()
        //        businessViewModel.reload()
        //        categoryCountViewModel.reload()
    }
    
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func reloadFetchControllers(){
        viewModel.reload()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        //        businessViewModel.reload()
        //        categoryCountViewModel.reload()
        //        DispatchQueue.main.async {
        //            self.tableView.reloadData()
        //        }
    }
}
