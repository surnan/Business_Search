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

    //MARK:- Local Var
    let firstController = GroupsController()
    let secondController = MapController()
//    let secondController = MapController2()
    

    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.green
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(handleLeftBarButton))
        //navigationItem.rightBarButtonItem = UIBarButtonItem(title: "STOP", style: .done, target: self, action: #selector(handleRight))
        navigationItem.title = categoryName
        
        firstController.tabBarItem =  UITabBarItem(title: "LIST", image: #imageLiteral(resourceName: "map-here2"), selectedImage: #imageLiteral(resourceName: "map-here"))
        secondController.tabBarItem = UITabBarItem(title: "MAP", image: #imageLiteral(resourceName: "map-here2"), selectedImage: #imageLiteral(resourceName: "map-here"))
        
        let tabBarList = [firstController, secondController]
        viewControllers = tabBarList
    }
    
    @objc func handleRight(){
        print("")
    }
    
    @objc func handleLeftBarButton(){
        navigationController?.popViewController(animated: true)
    }
}

