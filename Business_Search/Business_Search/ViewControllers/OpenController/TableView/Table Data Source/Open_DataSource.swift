//
//  Open_DataSource.swift
//  Business_Search
//
//  Created by admin on 7/30/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import MapKit

class Open_DataSource: NSObject, UITableViewDataSource {
    let businessViewModel           : BusinessViewModel
    let categoryNameCountViewModel  : CategoryCountViewModel
    let favoriteViewModel           : FavoritesViewModel
    let dataController              : DataController
    let parent                      : DataSourceType
    var tableArrayType: Int {return parent.tableViewArrayType}
    var location                    : CLLocation!
    
    init(parent: OpenController){
        self.parent             = parent
        self.businessViewModel  = parent.businessViewModel
        self.categoryNameCountViewModel  = parent.categoryCountViewModel
        self.dataController     = parent.dataController
        self.favoriteViewModel  = parent.favoritesViewModel
        self.location           = parent.location
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableArrayType {
        case TableIndex.business.rawValue:
            parent.showNothingLabel(tableEmpty: businessViewModel.isEmpty)
            return businessViewModel.getCount
        case TableIndex.category.rawValue:
            parent.showNothingLabel(tableEmpty: categoryNameCountViewModel.isEmpty)
            return categoryNameCountViewModel.getCount
        default:
            print("TableIndex.business.rawValue --> Invalid Value = \(TableIndex.business.rawValue)")
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableArrayType {
        case TableIndex.business.rawValue:
            let cell            = tableView.dequeueReusableCell(withIdentifier: businessCellID, for: indexPath) as! BusinessCell
            guard let business  = businessViewModel.objectAt(indexPath: indexPath) else {return UITableViewCell()}

            cell.firstViewModel = BusinessCellViewModel(business: business,
                                                        colorIndex: indexPath,
                                                        location: location)
            
            return cell
        case TableIndex.category.rawValue:
            let cell            = tableView.dequeueReusableCell(withIdentifier: categoryCellID, for: indexPath) as! CategoryCell
            let categoryName    = categoryNameCountViewModel.objectAt(indexPath: indexPath)
            cell.firstViewModel = CategoryCellViewModel(name: categoryName,
                                                        colorIndex: indexPath,
                                                        latitude: parent.getLatitude,
                                                        longitude: parent.getLongitude,
                                                        dataController: dataController)
            return cell
        default:
            print("TableIndex.business.rawValue --> Invalid Value = \(TableIndex.business.rawValue)")
            return UITableViewCell()
        }
    }
}
