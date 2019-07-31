//
//  MyDataSource+Protocol.swift
//  Business_Search
//
//  Created by admin on 7/4/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

extension OpeningTableDataSource: OpeningTableDataSourceProtocol  {
    
    func isBusinessFavorite(at indexPath: IndexPath) -> Bool {  //4
        // != nil.  Otherwise, tableView would be empty and can't have indexPath
        let currentBusiness = fetchBusinessController!.object(at: indexPath)
        return currentBusiness.isFavorite       //5
    }
    
    
    
    
    func updateCoordinates(latitude: Double, longitude: Double){
        self.latitude = latitude
        self.longitude = longitude
    }
    
    func getCategoryName(at index: Int) -> String {
        let categoryName = fetchCategoryNames![index]
        return categoryName
    }
    
    func getBusiness(at indexPath: IndexPath) -> Business {
        // != nil.  Otherwise, tableView would be empty and can't have indexPath
        let currentBusiness = fetchBusinessController!.object(at: indexPath)
        return currentBusiness
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
    
    func updateFavoritesPredicate(business: Business){  //1
        guard let id = business.id else {return}
        fetchFavoritePredicate = NSPredicate(format: "%K == %@", argumentArray: [#keyPath(Favorites.id), id])   //6 & 7
        fetchFavoritesController = nil  //8
    }
    
    func updateCategoryPredicate(category: String){
        selectedCategoryPredicate = NSPredicate(format: "title BEGINSWITH[cd] %@", argumentArray: [category])
        fetchCategoriesController = nil
    }
    
    func resetBusinessController() {fetchBusinessController = nil}
    func reloadCategoryController(){fetchCategoriesController = nil}
    func reloadCategoryNames() {fetchCategoryNames = nil}
    func reloadBusinessController(){fetchBusinessController = nil}
    
    func resetAllControllerAndPredicates() {
        fetchBusinessPredicate = nil
        fetchCategoryArrayNamesPredicate = nil
        fetchBusinessController = nil
        fetchCategoryNames = nil
        fetchFavoritePredicate = nil    //2
        fetchFavoritesController = nil //3
    }
    
}
