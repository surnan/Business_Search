//
//  OpeningController+TableView.swift
//  Business_Search
//
//  Created by admin on 5/1/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit


extension OpeningController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            print("numberOfRowsInSection - filteredBusinesses.count ---> \(filteredBusinesses!.count)")
            return filteredBusinesses!.count
        }
        
        return myFetchController?.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: defaultCellID, for: indexPath) as! DefaultCell
        
        cell.backgroundColor = colorArray[indexPath.row % colorArray.count]
        
        
        if searchController.isActive {
            if searchBarIsEmpty() {
                fetchPredicate = nil
                myFetchController = nil
            } else {
                let business4 = filteredBusinesses![indexPath.row]
                cell.textLabel?.text = business4.name
                return cell
            }
        }
        
        guard let business2 = myFetchController?.object(at: indexPath) else {
            let failCell = UITableViewCell()
            failCell.backgroundColor = UIColor.darkBlue
            failCell.textLabel?.text = "Failed to Get Data"
            return failCell
        }
        cell.textLabel!.text = business2.name
        return cell
    }
}

