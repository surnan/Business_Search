//
//  Open_Delegate.swift
//  Business_Search
//
//  Created by admin on 7/30/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class Open_Delegate: NSObject, UITableViewDelegate {
    private var coordinator: SearchTableCoordinator?
    private var parent: OpenController
    private var source: Open_DataSource
    private var reloadCellAt: IndexPath?
    
    init(parent: OpenController, source: Open_DataSource) {
        self.parent = parent
        self.source = source
        self.coordinator = parent.coordinator
    }
    
    private func reloadCellIfNecessary(tableView: UITableView) {
        guard let cellIndex = reloadCellAt else {return}
        tableView.reloadRows(at: [cellIndex], with: .none)
        reloadCellAt = nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        reloadCellAt = indexPath
        switch source.tableArrayType {
        case TableIndex.category.rawValue:
            guard let currentCategory = source.categoryViewModel.fetchCategoryNames?[indexPath.row] else {return}
            // let items = getBusinessesFromCategoryName(category: currentCategory)
            // coordinator?.loadTabController(businesses: items, categoryName: currentCategory)
        case TableIndex.business.rawValue:
            guard let currentBusiness = source.businessViewModel.fetchBusinessController?.object(at: indexPath) else {return}
            coordinator?.loadBusinessDetails(currentBusiness: currentBusiness)
        default:
            print("Illegal Value inside tableViewArrayType")
        }
    }
}


//func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    reloadCellAt = indexPath
//    switch delegate.getModel.tableViewArrayType {
//    case TableIndex.category.rawValue:
//        guard let currentCategory = delegate.getModel.fetchCategoryNames?[indexPath.row] else {return}
//        delegate.listBusinesses(category: currentCategory)
//    case TableIndex.business.rawValue:
//        guard let currentBusiness = delegate.getModel.fetchBusinessController?.object(at: indexPath) else {return}
//        delegate.loadBusinessDetails(currentBusiness: currentBusiness)
//    default:
//        print("Illegal Value inside tableViewArrayType")
//    }
//}
