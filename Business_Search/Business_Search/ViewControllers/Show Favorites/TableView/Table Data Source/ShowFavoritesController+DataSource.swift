//
//  ShowFavoritesController+DataSource.swift
//  Business_Search
//
//  Created by admin on 12/23/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import MapKit


class Favorite_DataSource: NSObject, UITableViewDataSource {
    
    let favoriteViewModel   : FavoriteBusinessViewModel
    var location            : CLLocation!
    
    init(parent: ShowFavoritesController){
        self.favoriteViewModel = parent.viewModel
        self.location = parent.location
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: businessCellID, for: indexPath) as! BusinessCell
        guard let business  = favoriteViewModel.objectAt(indexPath: indexPath) else {return UITableViewCell()}
        cell.firstViewModel = BusinessCellViewModel(business: business, colorIndex: indexPath, location: location)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteViewModel.fetchedObjects().count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("")
    }
}
