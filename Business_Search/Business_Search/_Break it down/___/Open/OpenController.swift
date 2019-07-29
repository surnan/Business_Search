//
//  OpenController.swift
//  Business_Search
//
//  Created by admin on 7/29/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData

class OpenController: UIViewController {
    var coordinator: SearchTableCoordinator?
    var viewModel: OpenViewModel!
    var viewObject: OpenView!
    var dataController: DataController!
    var latitude: Double!
    var longitude: Double!
    
    
    var tableView: UITableView = {
        let tableView = UITableView()
        
        return tableView
    }()
}




