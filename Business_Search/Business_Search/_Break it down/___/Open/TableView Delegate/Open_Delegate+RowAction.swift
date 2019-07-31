//
//  Open_Delegate+RowAction.swift
//  Business_Search
//
//  Created by admin on 7/30/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

extension Open_Delegate {
    //MARK:- ROW RIGHT-SIDE ACTIONS
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        //
        let actionForBusiness = UITableViewRowAction(style: .normal, title: "SHARE") {[unowned self] (action, indexPath) in
            guard let currentBusiness = self.source.businessViewModel.fetchBusinessController?.object(at: indexPath) else {return}
            self.shareBusiness(business: currentBusiness)   //3
        }
        //
        let actionForCategory = UITableViewRowAction(style: .normal, title: "RANDOM") {[unowned self] (action, indexPath) in
            let currentCategory = self.getCategoryName(at: indexPath.row)      //1
            let items           = self.getBusinessesFromCategoryName(category: currentCategory)
            self.showRandomBusiness(businesses: items)  //2
        }
        //
        actionForBusiness.backgroundColor = .red
        actionForCategory.backgroundColor = .blue
        return source.tableArrayType == TableIndex.category.rawValue ? [actionForCategory] : [actionForBusiness]
    }
    
    func getCategoryName(at index: Int) -> String {     //1
        guard let categoryNames = source.categoryNameCountViewModel.fetchCategoryNames else {return ""}
        let categoryName = categoryNames[index]
        return categoryName
    }
    
    func showRandomBusiness(businesses: [Business]){    //2
        if businesses.isEmpty {return}
        let modder          = businesses.count - 1
        let randomNumber    = Int.random(in: 0...modder)
        self.parent.coordinator?.loadBusinessDetails(currentBusiness: businesses[randomNumber])
    }
    
    func shareBusiness(business: Business){             //3
        let prependText = UserDefaults.standard.object(forKey: AppConstants.greetingMessage.rawValue) as? String
            ?? "Please check this link. \n"
        guard let temp = business.url else {return}
        let items: [Any] = ["\(prependText) \(temp)"]
        coordinator?.shareItems(items: items)
    }
}

extension Open_Delegate {
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //if delegate.getModel.tableViewArrayType == TableIndex.category.rawValue {return nil}
        //let currentBusiness = dataDelegate.getBusiness(at: indexPath)
        if source.tableArrayType == TableIndex.category.rawValue {return nil}
        guard let currentBusiness = source.businessViewModel.fetchBusinessController?.object(at: indexPath) else {return nil}
        let action = UIContextualAction(style: .normal, title: "Favorite") { [weak self] (action, view, myBool) in
            //guard let self  = self, let dd = self.dataDelegate, let delegate = self.delegate else {return}
            guard let self = self else {return}
            //            let isFavorite  = delegate.updateBusinessIsFavorite(business: currentBusiness)
            //            isFavorite ? delegate.createFavorite(business: currentBusiness)
            //                :delegate.deleteFavorite(business: currentBusiness)
            //            dd.resetBusinessController()
            //            delegate.reloadData()
            myBool(true)                                //Dismiss the leading swipe from UI
        }
        action.image            = currentBusiness.isFavorite    ?  #imageLiteral(resourceName: "cancel") : #imageLiteral(resourceName: "Favorite")
        action.backgroundColor  =  currentBusiness.isFavorite   ? .lightSteelBlue1 : .orange
        let configuration       = UISwipeActionsConfiguration(actions: [action])
        return configuration
    }
}
