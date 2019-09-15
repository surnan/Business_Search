//
//  GroupsController.swift
//  Business_Search
//
//  Created by admin on 5/3/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData


class GroupTableViewController: UITableViewController {
    var businesses = [Business]()   //injected
    var categoryName: String!       //injected
    var coordinator: (BusinessDetailsType & DismissType)?

    override var preferredStatusBarStyle: UIStatusBarStyle {return .lightContent}
    
    func sort(){
        businesses.sort { (first, second) -> Bool in
            return first.name ?? "" < second.name ?? ""
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor    = .lightBlue
        view.backgroundColor = .white
        tableView.register(BusinessCell.self, forCellReuseIdentifier: businessCellID)
        tableView.separatorColor = UIColor.clear
        setupNavigationBar()
        sort()
        tableView.reloadData()
    }
    
    func setupNavigationBar(){
        navigationController?.isNavigationBarHidden = false
        navigationItem.title = categoryName
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Dismiss", style: .plain, target: self,
                                                           action: #selector(handleDismiss))
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businesses.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: businessCellID, for: indexPath) as! BusinessCell
        cell.firstViewModel = BusinessCellViewModel(business: businesses[indexPath.row],colorIndex: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    

    
    @objc func handleDismiss(){
        coordinator?.handleDismiss()
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentBusiness = businesses[indexPath.row]
        coordinator?.loadBusinessDetails(currentBusiness: currentBusiness)
    }
}
