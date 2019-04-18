//
//  FirstController+TableView.swift
//  Business_Search
//
//  Created by admin on 4/16/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
let defaultCellID = "defaultCellID"

protocol TestProtocol {
    var getNameTitle: String {get}
    var getIdAlias: String   {get}
}

struct BusinessesStruct: TestProtocol{
    var id: String
    var name: String
    var getNameTitle: String {return name}
    var getIdAlias: String {return id}
}

struct CategoriesStruct: TestProtocol{
    var alias: String
    var title: String
    var getNameTitle: String {return title}
    var getIdAlias: String {return alias}
}

enum IndexOf: Int, CaseIterable {
    case business = 0
    case categories = 1
}


class ResultsTableViewController:UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    var tableViewArray = [[TestProtocol]]()
    var indexValue = 0
    var inputString = ""
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        indexValue = selectedScope
        tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        if text.count != 0 {
            inputString = text
            _ = Yelp.getAutoInputResults(text: text, latitude: 37.786882, longitude: -122.399972, completion: handleUpdateSearchResult(data:error:))
            print("")
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        IndexOf.allCases.forEach{_ in tableViewArray.append( [TestProtocol]())}
        tableView.register(DefaultCell.self, forCellReuseIdentifier: defaultCellID)
        tableView.backgroundColor = UIColor.lightBlue
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewArray[indexValue].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: defaultCellID, for: indexPath) as! DefaultCell
        cell.myLabel.text = tableViewArray[indexValue][indexPath.row].getNameTitle
        cell.backgroundColor = colorArray[indexPath.row % colorArray.count]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
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

        //tableViewArray.removeAll()    //crash
        tableViewArray[IndexOf.business.rawValue].removeAll()
        tableViewArray[IndexOf.categories.rawValue].removeAll()

        data.businesses.forEach{tableViewArray[IndexOf.business.rawValue].append(BusinessesStruct(id: $0.id, name: $0.name))}
        
        //Yelp will sometimes return categories that don't contain substring
        data.categories.forEach { (element) in
            if element.title.contains(inputString){
                tableViewArray[IndexOf.categories.rawValue].append(CategoriesStruct(alias: element.alias, title: element.title))
            }
        }
        tableView.reloadData()
        print("")
    }
}
