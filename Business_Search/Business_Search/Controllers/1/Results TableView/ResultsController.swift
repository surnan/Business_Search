//
//  FirstController+TableView.swift
//  Business_Search
//
//  Created by admin on 4/16/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData

//let defaultCellID = "defaultCellID"


enum IndexOf: Int, CaseIterable {
    case business = 0
    case categories = 1
}


class ResultsController: UITableViewController, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate{
    var dataController: DataController!
    var myFetchController: NSFetchedResultsController<Business>!


    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        myFetchController?.delegate = nil
         self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        print("Results Loaded")
        super.viewDidLoad()
        setupFetchController()
        tableView.delegate = self
        tableView.register(BusinessCell.self, forCellReuseIdentifier: businessCellID)
        tableView.backgroundColor = UIColor.lightBlue
    }
}
