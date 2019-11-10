//
//  File.swift
//  Business_Search
//
//  Created by admin on 11/10/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

//let coor = location.coordinate
//let newViewModel = SearchByAddressViewModel(latitude: coor.latitude, longitude: coor.longitude)
//let newView = SearchByAddressView()
//newView.viewModel = newViewModel
//let newController = SearchByAddressController()
//newController.viewObject = newView
//newController.viewModel = newViewModel
//newController.coordinator = self

class ShowFavoritesController: UITableViewController {
    var coordinator : Coordinator?
    var viewModel   : ShowFavoritesViewModel!
    var viewObject  : ShowFavoritesView!
    var favoritesVM : FavoritesViewModel!
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = .yellow
        cell.textLabel?.text = "asdf"
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritesVM.fetchedObjects().count
    }
    
    
}
