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

protocol OpenControllerDelegate {
    //func currentSelected() won't give the auto-completes
    func currentSelected(_ indexPath: IndexPath)
    var getModel: MyDataSource {get}
    var getLatitude: Double {get}
    var getLongitude: Double {get}
    var getDataController: DataController {get}
    func listBusinesses(category: String)
    func showBusinessInfo(currentBusiness: Business)
    func shareBusiness(business: Business)
    func getBusinessesFromCategoryName(category: String)-> [Business]
    func createFavoriteEntity(business: Business, context: NSManagedObjectContext)
    func reloadData()
}

class MyDelegate: NSObject, UITableViewDelegate {
    var delegate: OpenControllerDelegate?
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch delegate?.getModel.tableViewArrayType {
        case TableIndex.category.rawValue:
            guard let currentCategory = delegate?.getModel.fetchCategoryNames?[indexPath.row] else {return}
            delegate?.listBusinesses(category: currentCategory)
        case TableIndex.business.rawValue:
            guard let currentBusiness = delegate?.getModel.fetchBusinessController?.object(at: indexPath) else {return}
            delegate?.showBusinessInfo(currentBusiness: currentBusiness)
        default:
            print("Illegal Value inside tableViewArrayType")
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let actionBusiness = UITableViewRowAction(style: .normal, title: "SHARE") { (action, indexPath) in
            guard let currentBusiness = self.delegate?.getModel.fetchBusinessController?.object(at: indexPath) else {return}
            self.delegate?.shareBusiness(business: currentBusiness)
        }
        actionBusiness.backgroundColor = .darkBlue
        let actionCategory = UITableViewRowAction(style: .normal, title: "RANDOM") { (action, indexPath) in
            guard let currentCategory = self.delegate?.getModel.fetchCategoryNames?[indexPath.row] else {return}
            guard let items = self.delegate?.getBusinessesFromCategoryName(category: currentCategory) else {return}
            let modder = items.count - 1
            let randomNumber = Int.random(in: 0...modder)
            print(items[randomNumber].name ?? "")
            self.delegate?.showBusinessInfo(currentBusiness: items[randomNumber])
        }
        actionBusiness.backgroundColor = .red
        actionCategory.backgroundColor = .blue
        if delegate?.getModel.tableViewArrayType == TableIndex.category.rawValue {
            return [actionCategory]
        } else {
            return [actionBusiness]
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if delegate?.getModel.tableViewArrayType == TableIndex.category.rawValue {return nil}
        let action = UIContextualAction(style: .normal, title: "Favorite") { [weak self] (action, view, myBool) in
            guard let self = self else {return}
            guard let currentBusiness = self.delegate?.getModel.fetchBusinessController?.object(at: indexPath) else {return}
            let isFavorite = currentBusiness.isFavoriteChange(context: (self.delegate?.getDataController.viewContext)!) ///!
            myBool(true)    //Dismiss the leading swipe action
            tableView.reloadRows(at: [indexPath], with: .automatic)
            if isFavorite {
                self.delegate?.createFavoriteEntity(business: currentBusiness, context: (self.delegate?.getDataController.backGroundContext)!)  ///!
                self.delegate?.getModel.fetchBusinessController = nil
                self.delegate?.reloadData()
            } else {
                //self.model.deleteFavorite(business: currentBusiness)
                self.delegate?.getModel.fetchBusinessController = nil
                self.delegate?.reloadData()
                //TODO: delete favorite
                print("currentBusiness.id --> \(currentBusiness.id!)")
                print("")
            }
        }
        guard let currentBusiness = self.delegate?.getModel.fetchBusinessController?.object(at: indexPath) else {return nil}
        action.image = currentBusiness.isFavorite ?  #imageLiteral(resourceName: "cancel") : #imageLiteral(resourceName: "Favorite")
        action.backgroundColor =  currentBusiness.isFavorite ? .lightSteelBlue1 : .orange
        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
    }
}