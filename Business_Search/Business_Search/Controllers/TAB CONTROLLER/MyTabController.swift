//
//  TabController.swift
//  Business_Search
//
//  Created by admin on 4/18/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class MyTabController: UITabBarController {
    
    //MARK:- Injection Start
    var category: String!
    
    var businesses = [Business]()   {
        didSet {
            firstController.businesses = businesses //Populate TableView
            secondController.businesses = businesses    //populate array to build map
        }
    }
    
    var categoryName: String!  {
        didSet {
            navigationItem.title = categoryName
        }
    }

    let firstController = GroupsController()
    let secondController = MapController()
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.clear
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(handleLeftBarButton))
        navigationItem.title = categoryName
        firstController.tabBarItem =  UITabBarItem(title: "LIST", image: #imageLiteral(resourceName: "menu100B.png"), selectedImage: #imageLiteral(resourceName: "menu100B.png"))
        secondController.tabBarItem = UITabBarItem(title: "MAP", image: #imageLiteral(resourceName: "map100") , selectedImage: #imageLiteral(resourceName: "map100"))
        let tabBarList = [firstController, secondController]
        viewControllers = tabBarList
        tabBar.isTranslucent = false
    }
    
    @objc func handleRight(){
        print("")
    }
    
    @objc func handleLeftBarButton(){
        navigationController?.popViewController(animated: true)
    }
}

