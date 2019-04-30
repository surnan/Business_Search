//
//  FirstController+TableView.swift
//  Business_Search
//
//  Created by admin on 4/16/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData

let defaultCellID = "defaultCellID"


enum IndexOf: Int, CaseIterable {
    case business = 0
    case categories = 1
}


protocol ResultsControllerDelegate {
    func refreshCollectionView()
}

class ResultsController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate, ResultsControllerDelegate {
    var dataController: DataController!
    var myFetchController: NSFetchedResultsController<Business>!
    
    
    
    func refreshCollectionView() {
        print("")
    }
    
    var indexValue = 0
    var inputString = ""
    var delegate: SearchControllerProtocol?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        print("Results Loaded")
        super.viewDidLoad()
        setupFetchController()
        tableView.register(DefaultCell.self, forCellReuseIdentifier: defaultCellID)
        tableView.backgroundColor = UIColor.lightBlue
    }
}
