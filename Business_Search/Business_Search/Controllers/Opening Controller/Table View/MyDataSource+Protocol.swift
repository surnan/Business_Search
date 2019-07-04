//
//  MyDataSource+Protocol.swift
//  Business_Search
//
//  Created by admin on 7/4/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

extension MyDataSource {
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
}
