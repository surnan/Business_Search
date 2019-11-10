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
    var viewModel   : ShowFavoritesViewModel!
    var viewObject  : ShowFavoritesView!
    var favoritesVM : FavoritesViewModel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "PAUSE", style: .done, target: self, action: #selector(handleRightBarButton))
    }
    
    @objc func handleRightBarButton(){
        print("")
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = .yellow
        cell.textLabel?.text = "asdf"
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favoritesVM.reload()
        return favoritesVM.fetchedObjects().count
    }
    
    
}
