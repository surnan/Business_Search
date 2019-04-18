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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newVC =  MyTabController()
        newVC.category = tableViewArray[indexValue][indexPath.row].getNameTitle
        present(UINavigationController(rootViewController: newVC), animated: true) //Can't push into it
    }
}
