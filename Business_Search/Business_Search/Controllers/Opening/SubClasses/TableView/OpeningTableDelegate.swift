//
//  MyDelegate.swift
//  Business_Search
//
//  Created by admin on 7/3/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class OpeningTableDelegate: NSObject, UITableViewDelegate {
    var delegate: OpeningControllerProtocol!
    var dataDelegate      : OpeningTableDataSourceProtocol!
    
    init(delegate: OpeningControllerProtocol, dataSourceDelegate: OpeningTableDataSourceProtocol) {
        self.delegate   = delegate
        self.dataDelegate         = dataSourceDelegate
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if delegate.getModel.tableViewArrayType == TableIndex.category.rawValue {return nil}
        let currentBusiness = dataDelegate.getBusiness(at: indexPath)
        let action = UIContextualAction(style: .normal, title: "Favorite") { [weak self] (action, view, myBool) in
            guard let self  = self, let dd = self.dataDelegate, let delegate = self.delegate else {return}
            let isFavorite  = delegate.updateBusinessIsFavorite(business: currentBusiness)
            isFavorite ? delegate.createFavorite(business: currentBusiness)
                :delegate.deleteFavorite(business: currentBusiness)
            dd.resetBusinessController()
            delegate.reloadData()
            tableView.reloadRows(at: [indexPath], with: .automatic)
            myBool(true)                                //Dismiss the leading swipe from UI
        }
        action.image            = currentBusiness.isFavorite    ?  #imageLiteral(resourceName: "cancel") : #imageLiteral(resourceName: "Favorite")
        action.backgroundColor  =  currentBusiness.isFavorite   ? .lightSteelBlue1 : .orange
        let configuration       = UISwipeActionsConfiguration(actions: [action])
        return configuration
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch delegate.getModel.tableViewArrayType {
        case TableIndex.category.rawValue:
            guard let currentCategory = delegate.getModel.fetchCategoryNames?[indexPath.row] else {return}
            delegate.listBusinesses(category: currentCategory)
        case TableIndex.business.rawValue:
            guard let currentBusiness = delegate.getModel.fetchBusinessController?.object(at: indexPath) else {return}
            delegate.handleBusinessDetails(currentBusiness: currentBusiness)
        default:
            print("Illegal Value inside tableViewArrayType")
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let actionBusiness = UITableViewRowAction(style: .normal, title: "SHARE") { (action, indexPath) in
            guard let currentBusiness = self.delegate.getModel.fetchBusinessController?.object(at: indexPath) else {return}
            self.delegate.shareBusiness(business: currentBusiness)
        }
        actionBusiness.backgroundColor = .darkBlue
        let actionCategory = UITableViewRowAction(style: .normal, title: "RANDOM") { (action, indexPath) in
            let currentCategory = self.dataDelegate.getCategoryName(at: indexPath.row)
            let items           = self.delegate.getBusinessesFromCategoryName(category: currentCategory)
            let modder          = items.count - 1
            let randomNumber    = Int.random(in: 0...modder)
            self.delegate.handleBusinessDetails(currentBusiness: items[randomNumber])
        }
        actionBusiness.backgroundColor = .red
        actionCategory.backgroundColor = .blue
        return delegate.getModel.tableViewArrayType == TableIndex.category.rawValue ? [actionCategory]
            : [actionBusiness]
    }
}
