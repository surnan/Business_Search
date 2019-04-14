//
//  MyTabController.swift
//  Business_Search
//
//  Created by admin on 4/14/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class CustomTabController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Tap Location"
        
        tabBar.backgroundColor = UIColor.blue
        tabBar.tintColor = UIColor.white
        tabBar.barTintColor = UIColor.blue
        
        let firstController = MapController()
        firstController.tabBarItem =  UITabBarItem(title: "", image: #imageLiteral(resourceName: "map-here2"), selectedImage: #imageLiteral(resourceName: "map-here"))
        let secondController = MapController()
        secondController.tabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "map-here2"), selectedImage: #imageLiteral(resourceName: "map-here"))
        
        let tabBarList = [firstController, secondController]
        viewControllers = tabBarList
    }
}
