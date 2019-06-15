//
//  FavoritesController+UI.swift
//  Business_Search
//
//  Created by admin on 6/13/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData



extension FavoritesController{
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent       //Status bar sometimes turns black when typing into search bar
    }                              //Setting color scheme here just to play it safe
    
    func setupNavigationMenu(){
        navigationItem.title = "FAVORITES"
        navigationItem.searchController = searchController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        [tableView].forEach{view.addSubview($0)}
        tableView.fillSafeSuperView()
        fetchFavoriteBusinessController = nil
        setupNavigationMenu()
    }
}
