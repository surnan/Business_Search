//
//  Open_DataSource.swift
//  Business_Search
//
//  Created by admin on 7/30/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit


protocol DataSourceParent {
    
    var businessViewModel   : BusinessViewModel! {get}
    var categoryCountViewModel   : CategoryCountViewModel! {get}
    var getLatitude: Double {get}
    var getLongitude: Double {get}
    var dataController      : DataController! {get}
    var tableViewArrayType  : Int {get}
    func showNothingLabel(tableEmpty: Bool)
}

class Open_DataSource: NSObject, UITableViewDataSource {
    let businessViewModel           : BusinessViewModel
    let categoryNameCountViewModel  : CategoryCountViewModel
    let favoriteViewModel           : FavoritesViewModel
    
//    var latitude                    : Double
//    var longitude                   : Double

    let dataController              : DataController
    let parent                      : DataSourceParent
    var tableArrayType: Int {return parent.tableViewArrayType}
    
    
    
    init(parent: OpenController){
        self.parent             = parent
        self.businessViewModel  = parent.businessViewModel
        self.categoryNameCountViewModel  = parent.categoryCountViewModel
//        self.latitude           = parent.latitude
//        self.longitude          = parent.longitude
        self.dataController     = parent.dataController
        self.favoriteViewModel  = parent.favoritesViewModel
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
            print("numberOfRowsInSection --> WHOOOOOPS!!")
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableArrayType {
        case TableIndex.business.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: businessCellID, for: indexPath) as! BusinessCell
            
            //guard let business = businessViewModel.fetchBusinessController?.object(at: indexPath) else {return UITableViewCell()}
            let business = businessViewModel.objectAt(indexPath: indexPath)
            cell.firstViewModel = BusinessCellViewModel(business: business,colorIndex: indexPath)
            return cell
        case TableIndex.category.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: categoryCellID, for: indexPath) as! CategoryCell
            guard let currentCategoryName = categoryNameCountViewModel.fetchCategoryNames?[indexPath.row] else {return UITableViewCell()}
            cell.firstViewModel = CategoryCellViewModel(name: currentCategoryName, colorIndex: indexPath, latitude: parent.getLatitude, longitude: parent.getLongitude, dataController: dataController)
            return cell
        default:
            print("cellForRowAt --> WHOOOOOPS!!!")
            return UITableViewCell()
        }
    }
}
