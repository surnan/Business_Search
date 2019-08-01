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
        businessViewModel.reload()
        categoryCountViewModel.reload()
    }
    
    func searchBarIsEmpty() -> Bool {return searchController.searchBar.text?.isEmpty ?? true}

    func reloadFetchControllers(){
        businessViewModel.reload()
        categoryCountViewModel.reload()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
