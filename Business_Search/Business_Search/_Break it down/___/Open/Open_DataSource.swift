//
//  Open_DataSource.swift
//  Business_Search
//
//  Created by admin on 7/30/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit


protocol DataSourceParent {
    var businessViewModel: BusinessViewModel! {get}
    var categoryViewModel: CategoryViewModel! {get}
    var latitude: Double! {get}
    var longitude: Double! {get}
    var dataController: DataController! {get}
    var tableViewArrayType: Int {get}
}

class Open_DataSource: NSObject, UITableViewDataSource {
    let businessViewModel: BusinessViewModel
    let categoryViewModel: CategoryViewModel
    let latitude: Double
    let longitude: Double
    let dataController: DataController
    let parent: DataSourceParent
    
    init(parent: OpenController){
        self.parent = parent
        self.businessViewModel = parent.businessViewModel
        self.categoryViewModel = parent.categoryViewModel
        self.latitude = parent.latitude
        self.longitude = parent.longitude
        self.dataController = parent.dataController
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch parent.tableViewArrayType {
        case TableIndex.business.rawValue:
            return businessViewModel.getCount
        case TableIndex.category.rawValue:
            return categoryViewModel.getCount
        default:
            print("numberOfRowsInSection --> WHOOOOOPS!!")
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch parent.tableViewArrayType {
        case TableIndex.business.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: businessCellID, for: indexPath) as! BusinessCell
            guard let business = businessViewModel.fetchBusinessController?.object(at: indexPath) else {return UITableViewCell()}
            cell.firstViewModel = BusinessCellViewModel(business: business,colorIndex: indexPath)
            return cell
        case TableIndex.category.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: categoryCellID, for: indexPath) as! CategoryCell
            guard let currentCategoryName = categoryViewModel.fetchCategoryNames?[indexPath.row] else {
                return UITableViewCell()
            }
            cell.firstViewModel = CategoryCellViewModel(name: currentCategoryName, colorIndex: indexPath, latitude: latitude, longitude: longitude, dataController: dataController)
            return cell
        default:
            print("cellForRowAt --> WHOOOOOPS!!!")
            return UITableViewCell()
        }
    }
}
