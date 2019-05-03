//
//  OpeningController+TableView.swift
//  Business_Search
//
//  Created by admin on 5/1/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData

//categoryFinalArray

extension OpeningController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch GROUP_INDEX {
        case 0:
                    let state = fetchBusinessController?.fetchedObjects?.count ?? 0
                    ShowNothingLabelIfNoResults()
                return state
        case 1:
            let state = fetchCategoryController?.fetchedObjects?.count ?? 0
            return state
        default:
            print("WHOOOOOPS!!")
        }
        
        return 0
        /*
        let state = categoryFinalArray.count
        ShowNothingLabelIfNoResults()
        return state
        */
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        switch GROUP_INDEX {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: businessCellID, for: indexPath) as! BusinessCell
            cell.backgroundColor = colorArray[indexPath.row % colorArray.count]
            guard let currentBusiness = fetchBusinessController?.object(at: indexPath) else {
                print("tableView.cellForRowAt could not get cellData at indexPath: \(indexPath)")
                return UITableViewCell()
            }
            cell.textLabel!.text = currentBusiness.name
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: categoryCellID, for: indexPath) as! CategoryCell
            cell.backgroundColor = colorArray[indexPath.row % colorArray.count]
            guard let currentCategory = fetchCategoryController?.object(at: indexPath) else {
                print("tableView.cellForRowAt could not get cellData at indexPath: \(indexPath)")
                return UITableViewCell()
            }
            cell.category = currentCategory
            return cell
        default:
            print("Something Bad HAPPENED inside cellForRowAt:")
            return UITableViewCell()
        }
        
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: businessCellID, for: indexPath) as! BusinessCell
//        cell.backgroundColor = colorArray[indexPath.row % colorArray.count]
//
//
//        let currentCategoryName = categoryFinalArray[indexPath.row]
//
//
//        let _fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
//        let predicate2 = NSPredicate(format: "%K == %@", #keyPath(Category.title), currentCategoryName)
//        _fetchRequest.predicate = predicate2
//
//        let count: Int
//
//        do {
//            count = try dataController.viewContext.count(for: _fetchRequest)
//            cell.textLabel?.text = "\(currentCategoryName) ..... count = \(count)"
//            return cell
//        } catch {
//            print("Failed to get Count inside cellForRowAt: \n\(error)")
//        }
//
//
//        cell.textLabel?.text = "Failed to get Count at \(indexPath)"
//        return cell
    }
    
    func showNothingFoundView(){
        UIView.animate(withDuration: 1.0) {[unowned self] in
            self.nothingFoundView.alpha = 1
        }
    }
    
    func hideNothingFoundView(){
        nothingFoundView.alpha = 0
    }
    
    func ShowNothingLabelIfNoResults(){
        if fetchBusinessController?.fetchedObjects?.count == 0 && searchController.isActive && !searchBarIsEmpty(){
            showNothingFoundView()
        } else {
            hideNothingFoundView()
        }
    }
}

