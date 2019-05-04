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
    var dataController: DataController! //injected
    
    
    var businesses = [Business]()
    
    var fetchCategoryPredicate : NSPredicate? = nil
    

    
    
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.white
    }
    
    
    
    
}
