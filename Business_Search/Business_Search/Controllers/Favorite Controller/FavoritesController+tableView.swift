//
//  FavoritesController+tableView.swift
//  Business_Search
//
//  Created by admin on 6/13/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData



extension FavoritesController{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchFavoriteBusinessController?.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell2 = tableView.dequeueReusableCell(withIdentifier: favoriteBusinessCellID, for: indexPath) as! FavoriteBusinessCell
        cell2.backgroundColor = colorArray[indexPath.row % colorArray.count]
        cell2.favoriteBusiness = fetchFavoriteBusinessController?.object(at: indexPath)
        return cell2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Row selected @ \(indexPath)")
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let rowAction = UITableViewRowAction(style: .normal, title: "Delete") { (action, indexPath) in
            let currentBusiness = self.fetchFavoriteBusinessController?.object(at: indexPath)
            self.deleteFavorite(currentFavorite: currentBusiness!, indexPath: indexPath)
        }
        return [rowAction]
    }
}
