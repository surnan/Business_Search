//
//  ResultsTableViewController+TableView.swift
//  Business_Search
//
//  Created by admin on 4/18/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit


extension ResultsController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myFetchController?.fetchedObjects?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: businessCellID, for: indexPath) as! DefaultCell
        let business = myFetchController.object(at: indexPath)
        cell.myLabel.text = business.name
        cell.backgroundColor = colorArray[indexPath.row % colorArray.count]
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return myFetchController?.sections?.count ?? 1
    }
    
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let newVC =  MyTabController()
//        newVC.category = tableViewArray[indexValue][indexPath.row].getNameTitle
//        present(UINavigationController(rootViewController: newVC), animated: true) //Can't push into it
//    }
}
