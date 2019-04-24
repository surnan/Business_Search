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
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.green
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(handleLeftBarButton))
        
        let firstController = FirstController()
        let secondController = SecondController()
        let thirdController = ThirdController()
        
        firstController.tabBarItem =  UITabBarItem(title: "ONE", image: #imageLiteral(resourceName: "map-here2"), selectedImage: #imageLiteral(resourceName: "map-here"))
        secondController.tabBarItem = UITabBarItem(title: "TWO", image: #imageLiteral(resourceName: "map-here2"), selectedImage: #imageLiteral(resourceName: "map-here"))
        thirdController.tabBarItem = UITabBarItem(title: "THREE", image: #imageLiteral(resourceName: "map-here2"), selectedImage: #imageLiteral(resourceName: "map-here"))
        
        let tabBarList = [firstController, secondController, thirdController]
        viewControllers = tabBarList
    }
    
    
    @objc func handleLeftBarButton(){
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        //Can't set these in ViewDidLoad
        print("Category= \(category ?? "")")
//        urlSessionTask = Yelp.getNearbyBusinesses(category: category, latitude: latitude, longitude: longitude, completion: handlegetNearbyBusinesses(result:))
    }
}

