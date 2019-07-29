//
//  OpenController.swift
//  Business_Search
//
//  Created by admin on 7/29/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class OpenController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var coordinator: SearchTableCoordinator?
    var viewModel: OpenViewModel!
    var viewObject: OpenView!
    var dataController: DataController!
    var latitude: Double!
    var longitude: Double!
    
    
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CategoryCell.self, forCellReuseIdentifier: categoryCellID)
        tableView.register(BusinessCell.self, forCellReuseIdentifier: businessCellID)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchBusinessController = nil
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Pause", style: .done, target: self, action: #selector(handleRightBarButton))
        view.addSubview(tableView)
        tableView.fillSafeSuperView()
    }
    
    @objc func handleRightBarButton(){
        print("")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.fetchBusinessController?.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: businessCellID, for: indexPath) as! BusinessCell
        guard let business = viewModel.fetchBusinessController?.object(at: indexPath) else {return UITableViewCell()}
        cell.firstViewModel = BusinessCellViewModel(business: business,colorIndex: indexPath)
        return cell
    }
}




