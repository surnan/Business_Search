//
//  TabController.swift
//  Business_Search
//
//  Created by admin on 4/18/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class MyTabController: UITabBarController {
    //MARK:- Injections START
    var category: String!
    var categoryName: String!  {didSet {navigationItem.title = categoryName}}
    var businesses = [Business]()   {
        didSet {
            firstController.businesses = businesses     //Populate GroupsController.tableView
            secondController.businesses = businesses    //populate MapsController.mapView
        }
    }
    //MARK:- Injections END
    
    let firstController = GroupsController()
    let secondController = MapController()
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.clear
        navigationItem.title = categoryName
        firstController.tabBarItem =  UITabBarItem(title: "LIST", image: #imageLiteral(resourceName: "menu100B.png"), selectedImage: #imageLiteral(resourceName: "menu100B.png"))
        secondController.tabBarItem = UITabBarItem(title: "MAP", image: #imageLiteral(resourceName: "map100") , selectedImage: #imageLiteral(resourceName: "map100"))
        let tabBarList = [firstController, secondController]
        viewControllers = tabBarList
        tabBar.isTranslucent = false
    }
}

