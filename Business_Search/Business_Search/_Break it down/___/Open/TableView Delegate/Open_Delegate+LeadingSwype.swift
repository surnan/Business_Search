//
//  Open_Delegate+LeadingSwype.swift
//  Business_Search
//
//  Created by admin on 7/31/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData

extension Open_Delegate {
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if source.tableArrayType == TableIndex.category.rawValue {return nil}
        guard let currentBusiness = source.businessViewModel.fetchBusinessController?.object(at: indexPath) else {return nil}
        let action = UIContextualAction(style: .normal, title: "Favorite") { [unowned self] (action, view, myBool) in
            let isFavorite  = self.updateBusinessIsFavorite(business: currentBusiness)  //1
            isFavorite ? self.createFavorite(business: currentBusiness) : self.deleteFavorite(business: currentBusiness)    //3 & //4
            self.resetBusinessController()                                              //2
            self.parent.tableView.reloadData()
            myBool(true)                                //Dismiss the leading swipe from UI
        }
        action.image            = currentBusiness.isFavorite   ? #imageLiteral(resourceName: "cancel") : #imageLiteral(resourceName: "Favorite")
        action.backgroundColor  = currentBusiness.isFavorite   ? .lightSteelBlue1 : .orange
        let configuration       = UISwipeActionsConfiguration(actions: [action])
        return configuration
    }
    
    func updateBusinessIsFavorite(business: Business)->Bool{    //1
        return business.isFavoriteChange(context: dataController.viewContext)   //Core Data Extension
    }
    
    func resetBusinessController(){                             //2
        source.businessViewModel.fetchBusinessController = nil
    }

    func createFavorite(business: Business){                    //3
        source.favoriteViewModel.deleteFavorite(business: business)
    }
    
    func deleteFavorite(business: Business){                    //4
        source.favoriteViewModel.deleteFavorite(business: business)
    }
}
