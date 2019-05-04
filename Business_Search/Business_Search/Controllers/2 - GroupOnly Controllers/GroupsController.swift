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
    var businesses = [Business]()   //injected
    var categoryName: String! //injected
    

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businesses.count
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: businessCellID, for: indexPath) as! BusinessCell
//        cell.myLabel.text = businesses[indexPath.row].name
//        return cell
        
        let cell = tableView.dequeueReusableCell(withIdentifier: _businessCellID, for: indexPath) as! _BusinessCell
        cell.backgroundColor = colorArray[indexPath.row % colorArray.count]
        cell.currentBusiness = businesses[indexPath.row]
        return cell
        
    }
    
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.white
//        tableView.register(BusinessCell.self, forCellReuseIdentifier: businessCellID)
        tableView.register(_BusinessCell.self, forCellReuseIdentifier: _businessCellID)
        setupNavigationMenu()
    }
    
    func setupNavigationMenu(){
        let logo = UIImage(imageLiteralResourceName: "Inline-Logo")
        let imageView = UIImageView(image: logo)
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.title = categoryName
        
    }
    
    
}
