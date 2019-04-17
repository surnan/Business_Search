//
//  FirstController+TableView.swift
//  Business_Search
//
//  Created by admin on 4/16/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
let defaultCellID = "defaultCellID"

class ResultsTableViewController:UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        
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
}
