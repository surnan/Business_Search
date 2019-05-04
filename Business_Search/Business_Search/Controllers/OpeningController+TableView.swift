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
            let state = fetchCategoryArray?.count ?? 0
            ShowNothingLabelIfNoResults(group: tableViewArrayType)
            return state
        default:
            print("numberOfRowsInSection --> WHOOOOOPS!!")
        }
        return TableIndex.business.rawValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: businessCellID, for: indexPath) as! BusinessCell
        cell.backgroundColor = colorArray[indexPath.row % colorArray.count]
        
        switch tableViewArrayType {
        case TableIndex.business.rawValue:
            guard let currentBusiness = fetchBusinessController?.object(at: indexPath) else {
                print("tableView.cellForRowAt could not get cellData at indexPath: \(indexPath)")
                return UITableViewCell()
            }
            cell.textLabel!.text = currentBusiness.name
            return cell
        case TableIndex.category.rawValue:
            let currentCategoryName = fetchCategoryArray?[indexPath.row]
            let _fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
            let predicate2 = NSPredicate(format: "%K == %@", #keyPath(Category.title), currentCategoryName!)
            _fetchRequest.predicate = predicate2
            let count: Int
            do {
                count = try dataController.viewContext.count(for: _fetchRequest)
                cell.textLabel?.text = "\(currentCategoryName ?? "NO CATEGORY LISTED HERE") ..... count = \(count)"
                return cell
            } catch {
                print("Failed to get Count inside cellForRowAt: \n\(error)")
            }
            cell.textLabel?.text = "Failed to get Count at \(indexPath)"
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
            if fetchCategoryArray?.count == 0 && searchController.isActive && !searchBarIsEmpty(){
                showNothingFoundView()
            } else {
                hideNothingFoundView()
            }
        default:
            print("ShowNothingLabelIfNoResults --> is very unhappy")
        }
    }
}

