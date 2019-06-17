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
        switch tableViewArrayType {
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
    }
    
    func showBusinessInfo(currentBusiness: Business){
        let newVC = ShowBusinessDetailsController()
        newVC.business = currentBusiness
        navigationController?.pushViewController(newVC, animated: true)
    }
    
    func listBusinesses(category: String){
        //Not shown in this tableView.  It's to create array to push into next VC's tableView
        
        fetchFavoriteBusinessPredicate = NSPredicate(format: "title CONTAINS[cd] %@", argumentArray: [category])
        fetchFavoriteCategoriesController = nil
        
        var businessArray = [FavoriteBusiness]()    //Pushed into next ViewController
        fetchFavoriteCategoriesController?.fetchedObjects?.forEach{businessArray.append($0.favoriteBusiness!)}
        
        let newVC = MyTabController()
        newVC.favoriteBusinesses = businessArray
        newVC.categoryName = category
        navigationController?.pushViewController(newVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableViewArrayType {
        case TableIndex.category.rawValue:
            guard let currentCategory = fetchCategoryNames?[indexPath.row] else {return}
            listBusinesses(category: currentCategory)
        case TableIndex.business.rawValue:
            guard let currentBusiness = fetchBusinessController?.object(at: indexPath) else {return}
            showBusinessInfo(currentBusiness: currentBusiness)
        default:
            print("Illegal Value inside tableViewArrayType")
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let rowAction = UITableViewRowAction(style: .normal, title: "Delete") { (action, indexPath) in
            let currentBusiness = self.fetchFavoriteBusinessController?.object(at: indexPath)
            self.deleteFavorite(currentFavorite: currentBusiness!, indexPath: indexPath)
        }
        return [rowAction]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchGroupIndex == 0 ? fetchFavoriteBusinessController?.fetchedObjects?.count ?? 0 : fetchCategoryNames?.count ?? 0
    }
}
