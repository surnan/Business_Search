//
//  MyDataSource+Protocol.swift
//  Business_Search
//
//  Created by admin on 7/4/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

extension OpeningTableDataSource: OpeningTableDataSourceProtocol  {
    func getCategoryName(at index: Int) -> String {
        let categoryName = fetchCategoryNames![index]
        return categoryName
    }
    
    func getBusiness(at indexPath: IndexPath) -> Business {
        // != nil.  Otherwise, tableView would be empty and can't have indexPath
        let currentBusiness = fetchBusinessController!.object(at: indexPath)
        return currentBusiness
    }
    
    
    func isBusinessFavorite(at indexPath: IndexPath) -> Bool {
        // != nil.  Otherwise, tableView would be empty and can't have indexPath
        let currentBusiness = fetchBusinessController!.object(at: indexPath)
        return currentBusiness.isFavorite
    }
    
    func resetBusinessController() {
        fetchBusinessController = nil
    }

    func updateBusinessPredicate(id: String){
        fetchBusinessPredicate = NSPredicate(format: "id CONTAINS[cd] %@", argumentArray: [id])
        fetchBusinessController = nil
    }
    
    func updateBusinessPredicate(searchString: String){
        fetchBusinessPredicate = NSPredicate(format: "name CONTAINS[cd] %@", argumentArray: [searchString])
        fetchCategoryNames = nil
    }
    
    func updateCategoryArrayNamesPredicate(searchString: String){
        fetchCategoryArrayNamesPredicate = NSPredicate(format: "title CONTAINS[cd] %@", argumentArray: [searchString])
        fetchBusinessController = nil
    }
    
    func updateFavoritesPredicate(business: Business){
        guard let id = business.id else {return}
        fetchFavoritePredicate = NSPredicate(format: "%K == %@", argumentArray: [#keyPath(Favorites.id), id])
        fetchFavoritesController = nil
    }
    
    func updateCategoryPredicate(category: String){
        selectedCategoryPredicate = NSPredicate(format: "title BEGINSWITH[cd] %@", argumentArray: [category])
        fetchCategoriesController = nil
    }
    
    func reloadCategoryController(){
        fetchCategoriesController = nil
    }
    
    func reloadCategoryNames() {
        fetchCategoryNames = nil
    }
    
    
    func reloadBusinessController(){
        fetchBusinessController = nil
    }
    
    func resetAllControllerAndPredicates() {
        fetchBusinessPredicate = nil
        fetchCategoryArrayNamesPredicate = nil
        fetchBusinessController = nil
        fetchCategoryNames = nil
        fetchFavoritePredicate = nil
        fetchFavoritesController = nil
    }
    
}
