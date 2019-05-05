//
//  TabController.swift
//  Business_Search
//
//  Created by admin on 4/18/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class MyTabController: UITabBarController {
    
    var category: String!
    var urlSessionTask: URLSessionDataTask?
    
    
//    var dataController: DataController! //injected
    var businesses = [Business]()   {
        didSet {
            firstController.businesses = businesses
        }
    }
    
    var categoryName: String!  {
        didSet {
            navigationItem.title = categoryName
        }
    }

    let firstController = GroupsController()
    let secondController = GroupsController()
    
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.green
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(handleLeftBarButton))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "STOP", style: .done, target: self, action: #selector(handleRight))
        navigationItem.title = categoryName

        
        firstController.businesses = businesses
        firstController.categoryName = categoryName
        
        
        firstController.tabBarItem =  UITabBarItem(title: "ONE", image: #imageLiteral(resourceName: "map-here2"), selectedImage: #imageLiteral(resourceName: "map-here"))
        secondController.tabBarItem = UITabBarItem(title: "TWO", image: #imageLiteral(resourceName: "map-here2"), selectedImage: #imageLiteral(resourceName: "map-here"))
        
        let tabBarList = [firstController, secondController]
        viewControllers = tabBarList
    }
    
    @objc func handleRight(){
        print("")
    }
    
    @objc func handleLeftBarButton(){
        navigationController?.popViewController(animated: true)
    }
    

    
    
    override func viewDidAppear(_ animated: Bool) {
        //Can't set these in ViewDidLoad
        print("Category= \(category ?? "")")
//        urlSessionTask = Yelp.getNearbyBusinesses(category: category, latitude: latitude, longitude: longitude, completion: handlegetNearbyBusinesses(result:))
    }
}

