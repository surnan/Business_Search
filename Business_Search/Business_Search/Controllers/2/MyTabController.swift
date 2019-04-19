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
        
    }
    
    
    @objc func handleLeftBarButton(){
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        print("Category= \(category ?? "")")
        urlSessionTask = Yelp.getNearbyBusinesses(category: category, latitude: latitude, longitude: longitude, completion: handlegetNearbyBusinesses(result:))
    }
}
