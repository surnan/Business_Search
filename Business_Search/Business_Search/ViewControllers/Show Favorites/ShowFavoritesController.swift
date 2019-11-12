//
//  File.swift
//  Business_Search
//
//  Created by admin on 11/10/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit


class ShowFavoritesController: UITableViewController {
    var coordinator : Coordinator?
    var viewModel   : FavoriteBusinessViewModel!
    var viewObject  : ShowFavoritesView!
    var favoritesVM : FavoritesViewModel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.reload()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "PAUSE",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(handleRightBarButton))
        tableView.register(CategoryCell.self, forCellReuseIdentifier: categoryCellID)
        tableView.register(BusinessCell.self, forCellReuseIdentifier: businessCellID)
    }
    
    @objc func handleRightBarButton(){
        print("")
        viewModel.deleteAllFavorites()
        favoritesVM.deleteAllFavorites()
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: businessCellID, for: indexPath) as! BusinessCell
        guard let business  = viewModel.objectAt(indexPath: indexPath) else {return UITableViewCell()}
        cell.firstViewModel = BusinessCellViewModel(favoriteBusiness: business, colorIndex: indexPath)
        return cell
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.fetchedObjects().count
    }
}
