//
//  OpeningController+TableView.swift
//  Business_Search
//
//  Created by admin on 5/1/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData

extension OpeningController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let state = myFetchController?.fetchedObjects?.count ?? 0
        ShowNothingLabelIfNoResults()
        return state
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: defaultCellID, for: indexPath) as! DefaultCell
        cell.backgroundColor = colorArray[indexPath.row % colorArray.count]
        guard let currentBusiness = myFetchController?.object(at: indexPath) else {
            print("tableView.cellForRowAt could not get cellData at indexPath: \(indexPath)")
            return UITableViewCell()
        }
        cell.textLabel!.text = currentBusiness.name
        return cell
    }
    
    func showNothingFoundView(){
        UIView.animate(withDuration: 1.0) {[unowned self] in
            self.nothingFoundView.alpha = 1
        }
    }
    
    func hideNothingFoundView(){
        nothingFoundView.alpha = 0
    }
    
    func ShowNothingLabelIfNoResults(){
        if myFetchController?.fetchedObjects?.count == 0 && searchController.isActive && !searchBarIsEmpty(){
            showNothingFoundView()
        } else {
            hideNothingFoundView()
        }
    }
}

