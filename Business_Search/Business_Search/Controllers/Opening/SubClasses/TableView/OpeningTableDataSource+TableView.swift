//
//  MyDataSource+TableView.swift
//  Business_Search
//
//  Created by admin on 7/4/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData

extension OpeningTableDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableViewArrayType {
        case TableIndex.business.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: _businessCellID, for: indexPath) as! _BusinessCell
            guard let business = fetchBusinessController?.object(at: indexPath) else {return UITableViewCell()}
            cell.firstViewModel = MyBusinessViewModel(business: business,colorIndex: indexPath)
            return cell
        case TableIndex.category.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: categoryCellID, for: indexPath) as! CategoryCell
            guard let currentCategoryName = fetchCategoryNames?[indexPath.row] else {return UITableViewCell()}
            cell.firstViewModel = MyCategoryViewModel(name: currentCategoryName, colorIndex: indexPath, latitude: latitude, longitude: longitude, dataController: dataController)
            return cell
        default:
            print("Something Bad HAPPENED inside cellForRowAt:")
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableViewArrayType {
        case TableIndex.business.rawValue:
            let state = fetchBusinessController?.fetchedObjects?.count ?? 0
            ShowNothingLabelIfNoResults(state: state)
            return state
        case TableIndex.category.rawValue:
            let state = fetchCategoryNames?.count ?? 0
            ShowNothingLabelIfNoResults(state: state)
            return state
        default:
            print("numberOfRowsInSection --> WHOOOOOPS!!")
        }
        return TableIndex.business.rawValue
    }
    
    func ShowNothingLabelIfNoResults(state: Int){
        state == 0 ? model.showNothingFoundView() : model.hideNothingFoundView()
    }
}
