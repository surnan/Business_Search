//
//  GroupsController.swift
//  Business_Search
//
//  Created by admin on 5/3/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData


class GroupsController: UITableViewController {
    var businesses = [Business]()   //injected
    var categoryName: String!       //injected

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businesses.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: _businessCellID, for: indexPath) as! _BusinessCell
        cell.backgroundColor = colorArray[indexPath.row % colorArray.count]
        cell.currentBusiness = businesses[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        tableView.register(_BusinessCell.self, forCellReuseIdentifier: _businessCellID)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let newVC = BusinessDetailsController()
            newVC.business = businesses[indexPath.row]
            navigationController?.pushViewController(newVC, animated: true)
    }
}
