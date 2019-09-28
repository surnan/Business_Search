//
//  OpenControllerDelegate.swift
//  Business_Search
//
//  Created by admin on 7/5/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

protocol OpenControllerProtocol {
    var getModel: OpeningTableDataSource {get}
    func listBusinesses(category: String)
    func showBusinessInfo(currentBusiness: Business)
    func shareBusiness(business: Business)
    func getBusinessesFromCategoryName(category: String)-> [Business]
    func deleteFavorite(business: Business)
    func updateBusinessIsFavorite(business: Business)->Bool
    func reloadData()
    func createFavorite(business: Business)
}
