//
//  MyDataSource+TableView.swift
//  Business_Search
//
//  Created by admin on 7/4/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData

extension MyDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableViewArrayType {
        case TableIndex.business.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: _businessCellID, for: indexPath) as! _BusinessCell
            cell.backgroundColor = colorArray[indexPath.row % colorArray.count]
            cell.currentBusiness = fetchBusinessController?.object(at: indexPath)
            return cell
        case TableIndex.category.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: categoryCellID, for: indexPath) as! CategoryCell
            cell.backgroundColor = colorArray[indexPath.row % colorArray.count]
            let currentCategoryName = fetchCategoryNames?[indexPath.row]
            let _fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
            let myPredicate = NSPredicate(format: "%K == %@", #keyPath(Category.title), currentCategoryName!)
            let filterControllerPredicate = UserAppliedFilter.shared.getCategoryPredicate()        //FilterController() & Singleton
            var tempPredicate = [myPredicate, predicateCategoryLatitude, predicateCategoryLongitude]
            filterControllerPredicate.forEach{tempPredicate.append($0)}
            _fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: tempPredicate)
            
            cell.name = currentCategoryName
            do {
                let count = try dataController.viewContext.count(for: _fetchRequest)
                cell.count = count
            } catch {
                cell.count = 0
                print("Failed to get Count inside cellForRowAt: \n\(error)")
            }
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
    
    //func ShowNothingLabelIfNoResults(group: Int){
    func ShowNothingLabelIfNoResults(state: Int){
        state == 0 ? model.showNothingFoundView() : model.hideNothingFoundView()
    }
}
