//
//  File.swift
//  Business_Search
//
//  Created by admin on 11/10/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import MapKit


class ShowFavoritesController: UITableViewController {
    var coordinator : Coordinator?
    var viewModel   : FavoriteBusinessViewModel!
    var viewObject  : ShowFavoritesView!
    var favoritesVM : FavoritesViewModel!

    
    /////////////////////////////////////////////////
    var currentLatitude : Double!
    var currentLongitude: Double!
    var location        : CLLocation!
    /////////////////////////////////////////////////
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.reload()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "PAUSE",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(handleRightBarButton))
        tableView.register(CategoryCell.self, forCellReuseIdentifier: categoryCellID)
        tableView.register(BusinessCell.self, forCellReuseIdentifier: businessCellID)
        location = CLLocation(latitude: currentLatitude, longitude: currentLongitude)
    }
    
    @objc func handleRightBarButton(){
        print("")
        viewModel.deleteAllFavorites()
        favoritesVM.deleteAllFavorites()
    }
    
    
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
    
}
