//
//  FavoritesController+tableView.swift
//  Business_Search
//
//  Created by admin on 6/13/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData



extension FavoritesController{

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch searchGroupIndex {
        case TableIndex.business.rawValue:
            let cell2 = tableView.dequeueReusableCell(withIdentifier: favoriteBusinessCellID, for: indexPath) as! FavoriteBusinessCell
            cell2.backgroundColor = colorArray[indexPath.row % colorArray.count]
            cell2.favoriteBusiness = fetchFavoriteBusinessController?.object(at: indexPath)
            return cell2
        case TableIndex.category.rawValue:
            let cell2 = tableView.dequeueReusableCell(withIdentifier: categoryCellID, for: indexPath) as! CategoryCell
            cell2.backgroundColor = colorArray[indexPath.row % colorArray.count]
            let currentCategoryName = fetchCategoryNames?[indexPath.row]
            
            let _fetchRequest: NSFetchRequest<FavoriteCategory> = FavoriteCategory.fetchRequest()
            let myPredicate = NSPredicate(format: "%K == %@", #keyPath(Category.title), currentCategoryName!)
            _fetchRequest.predicate = myPredicate
            
            cell2.name = currentCategoryName
            
            do{
                let count = try dataController.viewContext.count(for: _fetchRequest)
                cell2.count = count
            } catch {
                cell2.count = 0
                print("Failed to get Count inside cellForRowAt: \n\(error)")
                return cell2
            }
            return cell2
        default:
            print("Error: FavoriteController.cellForRowAt: \nInvalid value for searchGroupIndex.")
            return UITableViewCell()
        }
        print("Error: Skip switch FavoriteController.cellForRowAt:")
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Row selected @ \(indexPath)")
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let rowAction = UITableViewRowAction(style: .normal, title: "Delete") { (action, indexPath) in
            let currentBusiness = self.fetchFavoriteBusinessController?.object(at: indexPath)
            self.deleteFavorite(currentFavorite: currentBusiness!, indexPath: indexPath)
        }
        return [rowAction]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return fetchFavoriteBusinessController?.fetchedObjects?.count ?? 0
        if searchGroupIndex == TableIndex.business.rawValue {
          return fetchFavoriteBusinessController?.fetchedObjects?.count ?? 0
        }
        
        return fetchCategoryNames?.count ?? 0
        
        
    }
}
