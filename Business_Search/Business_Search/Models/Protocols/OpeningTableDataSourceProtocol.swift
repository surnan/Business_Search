//
//  OpeningTableDataSourceDelegate.swift
//  Business_Search
//
//  Created by admin on 7/5/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

protocol OpeningTableDataSourceProtocol {
    func getBusiness(at indexPath: IndexPath)->Business
    func getCategoryName(at index: Int)->String
    func resetBusinessController()
    func resetAllControllerAndPredicates()
    func reloadCategoryNames()
    func reloadBusinessController()
    func reloadCategoryController()
    func updateCategoryPredicate(category: String)
    func updateFavoritesPredicate(business: Business)
    func updateBusinessPredicate(searchString: String)
    func updateCategoryArrayNamesPredicate(searchString: String)
    func updateBusinessPredicate(id: String)
}
