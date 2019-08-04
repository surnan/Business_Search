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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        setupNavigationBar()
    }
    
    func setupNavigationBar(){
        //navigationController?.isNavigationBarHidden = true   //hides the searchController bar
        navigationItem.title = "categoryName2"
        navigationController?.title = "categoryName"
    }
    
}
