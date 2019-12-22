//
//  ShowFavoritesController+TableView.swift
//  Business_Search
//
//  Created by admin on 12/4/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

extension ShowFavoritesController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: businessCellID, for: indexPath) as! BusinessCell
        guard let business  = viewModel.objectAt(indexPath: indexPath) else {return UITableViewCell()}
        cell.firstViewModel = BusinessCellViewModel(business: business, colorIndex: indexPath, location: location)
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.fetchedObjects().count
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("")
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
                let action = UIContextualAction(style: .normal, title: "Favorite") { [unowned self] (action, view, myBool) in
                    myBool(true)                                //Dismiss the leading swipe from UI
                }

        action.image            =  #imageLiteral(resourceName: "cancel")
        action.backgroundColor  =  .lightSteelBlue2
        
        let configuration       = UISwipeActionsConfiguration(actions: [action])
        return configuration
    }
}
