//
//  OpeningController+TableView.swift
//  Business_Search
//
//  Created by admin on 5/1/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData

extension OpeningController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableViewArrayType {
        case TableIndex.business.rawValue:
            let state = fetchBusinessController?.fetchedObjects?.count ?? 0
            ShowNothingLabelIfNoResults(group: tableViewArrayType)
            return state
        case TableIndex.category.rawValue:
            let state = fetchCategoryNames?.count ?? 0
            ShowNothingLabelIfNoResults(group: tableViewArrayType)
            return state
        default:
            print("numberOfRowsInSection --> WHOOOOOPS!!")
        }
        return TableIndex.business.rawValue
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
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
            
            _fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [myPredicate,
                                                                                         predicateCatLatitude,
                                                                                         predicateCatLongitude])
            
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
    
    private func showNothingFoundView(){
        UIView.animate(withDuration: 1.0) {[unowned self] in
            self.nothingFoundView.alpha = 1
        }
    }
    
    private func hideNothingFoundView(){
        nothingFoundView.alpha = 0
    }
    
    
    func ShowNothingLabelIfNoResults(group: Int){
        switch group {
        case TableIndex.business.rawValue:
            if fetchBusinessController?.fetchedObjects?.count == 0 && searchController.isActive && !searchBarIsEmpty(){
                showNothingFoundView()
            } else {
                hideNothingFoundView()
            }
        case TableIndex.category.rawValue:
            if fetchCategoryNames?.count == 0 && searchController.isActive && !searchBarIsEmpty(){
                showNothingFoundView()
            } else {
                hideNothingFoundView()
            }
        default:
            print("ShowNothingLabelIfNoResults --> is very unhappy")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if tableViewArrayType == TableIndex.category.rawValue {
            guard let currentCategory = fetchCategoryNames?[indexPath.row] else {return}
            listBusinesses(category: currentCategory)
        }
        
        if tableViewArrayType == TableIndex.business.rawValue {
            guard let currentBusiness = fetchBusinessController?.object(at: indexPath) else {return}
            showBusinessInfo(currentBusiness: currentBusiness)
        }
    }
    
    
    
    func showBusinessInfo(currentBusiness: Business){
        let newVC = BusinessController()
        newVC.business = currentBusiness
        navigationController?.pushViewController(newVC, animated: true)
    }
    
    
    func listBusinesses(category: String){
        //Not shown in this tableView.  It's to create array to push into next VC's tableView
        selectedCategoryPredicate = NSPredicate(format: "title CONTAINS[cd] %@", argumentArray: [category])
        fetchCategoriesController = nil
        
        var businessArray = [Business]()
        fetchCategoriesController?.fetchedObjects?.forEach{businessArray.append($0.business!)}

        businessArray = businessArray.filter{
            return $0.parentLocation?.latitude == currentLatitude &&
                $0.parentLocation?.longitude == currentLongitude }
        
        
        let newVC2 = MyTabController()
        newVC2.businesses = businessArray
        newVC2.categoryName = category
        navigationController?.pushViewController(newVC2, animated: true)
    }
}

