//
//  ResultsController+Search.swift
//  Business_Search
//
//  Created by admin on 4/18/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

extension ResultsController {
    //SearchController defines Results Controller as data source
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        indexValue = selectedScope
        tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        if text.count != 0 {
            inputString = text
            urlSessionTask?.cancel()
            urlSessionTask = Yelp.getAutoInputResults(text: text, latitude: 37.786882, longitude: -122.399972, completion: handleUpdateSearchResult(result:))
            print("Yelp Auto-Complete Call")
            tableView.reloadData()
        }
    }
}

/*
 func updateSearchResults(for searchController: UISearchController) {
 guard let text = searchController.searchBar.text else { return }
 if text.count != 0 && urlSessionTask == nil {
 inputString = text
 urlSessionTask = Yelp.getAutoInputResults(text: text, latitude: 37.786882, longitude: -122.399972, completion: handleUpdateSearchResult(result:))
 print("Yelp Auto-Complete Call")
 tableView.reloadData()
 } else {
 print("skipped network request")
 }
 }

 */
