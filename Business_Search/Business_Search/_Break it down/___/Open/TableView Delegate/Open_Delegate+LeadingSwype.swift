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
    //MARK:- ROW Left-SIDE ACTIONS
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if source.tableArrayType == TableIndex.category.rawValue {return nil}
        guard let currentBusiness = source.businessViewModel.fetchBusinessController?.object(at: indexPath) else {return nil}
        let action = UIContextualAction(style: .normal, title: "Favorite") { [unowned self] (action, view, myBool) in
            let reset       = {self.source.businessViewModel.reload()}
            let isFavorite  = {self.source.favoriteViewModel.changeFavorite(business: currentBusiness)}
            let create      = {self.source.favoriteViewModel.createFavorite(business: currentBusiness)}
            let delete      = {self.source.favoriteViewModel.deleteFavorite(business: currentBusiness)}
            isFavorite() ? create() : delete()
            reset()
            self.parent.tableView.reloadData()
            myBool(true)                                //Dismiss the leading swipe from UI
        }
        action.image            = currentBusiness.isFavorite   ? #imageLiteral(resourceName: "cancel") : #imageLiteral(resourceName: "Favorite")
        action.backgroundColor  = currentBusiness.isFavorite   ? .lightSteelBlue1 : .orange
        let configuration       = UISwipeActionsConfiguration(actions: [action])
        return configuration
    }
}

