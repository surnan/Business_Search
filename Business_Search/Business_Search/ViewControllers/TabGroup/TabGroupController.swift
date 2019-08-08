//
//  TabController.swift
//  Business_Search
//
//  Created by admin on 4/18/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class TabGroupController: UITabBarController {
    //MARK:- Injections START
    var category: String!
    var categoryName: String!  {didSet {navigationItem.title = categoryName}}
    var businesses = [Business]()

    override var preferredStatusBarStyle: UIStatusBarStyle {return .lightContent}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
    }
}

