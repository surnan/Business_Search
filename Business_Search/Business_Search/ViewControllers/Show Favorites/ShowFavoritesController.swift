//
//  File.swift
//  Business_Search
//
//  Created by admin on 11/10/19.
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

//class ShowFavoritesController: UITableViewController {
class ShowFavoritesController: UIViewController, UITableViewDelegate {
    var coordinator : Coordinator?
    var viewModel   : FavoriteBusinessViewModel!
    var viewObject  : ShowFavoritesView!
    var favoritesVM : FavoritesViewModel!

    
    /////////////////////////////////////////////////
    var currentLatitude : Double!
    var currentLongitude: Double!
    var location        : CLLocation!
    /////////////////////////////////////////////////
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CategoryCell.self, forCellReuseIdentifier: categoryCellID)
        tableView.register(BusinessCell.self, forCellReuseIdentifier: businessCellID)
        tableView.rowHeight = 70
        tableView.separatorColor = UIColor.clear
        tableView.keyboardDismissMode = UIScrollView.KeyboardDismissMode.onDrag
        return tableView
    }()
    /////////////////////////////////////////////////
    
    lazy var tableDataSource    = Favorite_DataSource(parent: self)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        //BLANK TABLE - tableView.dataSource = Favorite_DataSource(parent: self) //Instance will be immediately deallocated because property 'dataSource' is weak
        tableView.dataSource = tableDataSource
        //tableView.delegate = tableDelegate
        
        viewModel.reload()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "PAUSE",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(handleRightBarButton))
        location = CLLocation(latitude: currentLatitude, longitude: currentLongitude)
    }
    
    
    func setupUI(){
        [tableView].forEach{view.addSubview($0)}
        tableView.fillSafeSuperView()
    }
    
    
    
    @objc func handleRightBarButton(){
        print("")
        viewModel.deleteAllFavorites()
        favoritesVM.deleteAllFavorites()
    }
    
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: businessCellID, for: indexPath) as! BusinessCell
//        guard let business  = viewModel.objectAt(indexPath: indexPath) else {return UITableViewCell()}
//        cell.firstViewModel = BusinessCellViewModel(business: business, colorIndex: indexPath, location: location)
//        return cell
//    }
//
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return viewModel.fetchedObjects().count
//    }
//
//
//
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("")
//    }
    
}
