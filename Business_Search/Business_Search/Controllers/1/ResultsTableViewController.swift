//
//  FirstController+TableView.swift
//  Business_Search
//
//  Created by admin on 4/16/19.
//  Copyright © 2019 admin. All rights reserved.
//

/*
 struct BusinessesStruct: Codable {
 var id: String
 var name: String
 }
 
 struct CategoriesStruct: Codable {
 var alias: String
 var title: String
 }
 
 struct TermsStruct: Codable {
 var text: String
 }
 */

import UIKit
let defaultCellID = "defaultCellID"

class ResultsTableViewController:UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    struct BusinessesStruct{
        var id: String
        var name: String
    }
    
    struct CategoriesStruct{
        var alias: String
        var title: String
    }

    let businessScope = 0
    let categoriesScope = 1
    
    var businessArray = [AutoCompleteResponse.BusinessesStruct]()
    var categoriesArray = [AutoCompleteResponse.CategoriesStruct]()
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        print("2 - New scope index is now \(selectedScope)")
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        if text.count != 0 {
            _ = Yelp.getAutoInputResults(text: text, latitude: 37.786882, longitude: -122.399972, completion: handleUpdateSearchResult(data:error:))
        }
    }
    
    override func viewDidLoad() {
        tableView.register(DefaultCell.self, forCellReuseIdentifier: defaultCellID)
        tableView.backgroundColor = UIColor.orange
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: defaultCellID, for: indexPath) as! DefaultCell
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    func handleUpdateSearchResult(data: AutoCompleteResponse?, error: Error?){
        if let err = error {
            print("Error:\n\(err)")
            return
        }
        guard let data = data else {
            print("No Error and No Data")
            return
        }
        businessArray = data.businesses
        categoriesArray = data.categories
    }
}
