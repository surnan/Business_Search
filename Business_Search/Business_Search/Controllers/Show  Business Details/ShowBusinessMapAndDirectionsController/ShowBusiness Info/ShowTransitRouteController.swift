//
//  ShowBusinessTransitTableViewController.swift
//  Business_Search
//
//  Created by admin on 6/1/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit



class ShowTransitRouteController: UITableViewController {

    var transitSteps = [[String]]()
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return transitSteps.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transitSteps[section].count - 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
         let myText = transitSteps[indexPath.section][indexPath.row + 1]
        cell.textLabel?.text = "\(indexPath) -> \(myText)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return transitSteps[section].first
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("transitSteps:\n\(transitSteps)")
    }
    
    
}
