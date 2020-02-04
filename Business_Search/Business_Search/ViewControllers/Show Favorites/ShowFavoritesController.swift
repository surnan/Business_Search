//
//  File.swift
//  Business_Search
//
//  Created by admin on 11/10/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import MapKit


class ShowFavoritesController: UIViewController, UITableViewDelegate {
    var coordinator : Coordinator?
    var viewModel   : FavoriteBusinessViewModel!
    var viewObject  : ShowFavoritesView!
    var favoritesVM : FavoritesViewModel!
    
    var currentLatitude : Double!
    var currentLongitude: Double!
    var location        : CLLocation!
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CategoryCell.self, forCellReuseIdentifier: categoryCellID)
        tableView.register(BusinessCell.self, forCellReuseIdentifier: businessCellID)
        tableView.rowHeight = 70
        tableView.separatorColor = UIColor.clear
        tableView.keyboardDismissMode = UIScrollView.KeyboardDismissMode.onDrag
        return tableView
    }()
    
    lazy var tableDataSource    = Favorite_DataSource(parent: self)
    //lazy var tableDelegate    = 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        //BLANK TABLE - tableView.dataSource = Favorite_DataSource(parent: self)
        //Instance will be immediately deallocated because property 'dataSource' is weak
        tableView.dataSource = tableDataSource
        //tableView.delegate = tableDelegate
        tableView.delegate = self
        
        viewModel.reload()
        
        location = CLLocation(latitude: currentLatitude, longitude: currentLongitude)
    }
    
    
    func setupUI(){
        navigationItem.rightBarButtonItems    = [getSortOrderBarButton(selector: #selector(handleOrderSortBarButton))]
        
        [tableView].forEach{view.addSubview($0)}
        tableView.fillSafeSuperView()
    }
    
    @objc func handleOrderSortBarButton(){
        UserAppliedFilter.shared.updateBusinessSortDescriptor()
        //reloadFetchControllers()
        navigationItem.rightBarButtonItems    = [getSortOrderBarButton(selector: #selector(handleOrderSortBarButton))]
    }
    
    @objc func tempFunction(){}
    
    
    @objc func handleRightBarButton(){
        print("")
        viewModel.deleteAllFavorites()
        favoritesVM.deleteAllFavorites()
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        //        let actionForBusiness = UITableViewRowAction(style: .normal, title: "SHARE") {[unowned self] (action, indexPath) in
        //            if let currentBusiness = self.source.businessViewModel.objectAt(indexPath: indexPath) {
        //                self.shareBusiness(business: currentBusiness)   //3
        //            }
        //        }
        let actionForBusiness = UITableViewRowAction(style: .normal, title: "AA") { (action, indexPath) in
        }
        
        actionForBusiness.backgroundColor = #colorLiteral(red: 0, green: 0.5628422499, blue: 0.3188166618, alpha: 1)
        return [actionForBusiness]
    }
    
//    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        if source.tableArrayType == TableIndex.category.rawValue {return nil}
//        guard let currentBusiness = source.businessViewModel.objectAt(indexPath: indexPath) else {return nil}
//        
//        let action = UIContextualAction(style: .normal, title: "Favorite") { [unowned self] (action, view, myBool) in
//            let reset       = {self.source.businessViewModel.reload()}
//            let isFavorite  = {self.source.favoriteViewModel.changeFavoriteOnBusinessEntity(business: currentBusiness)}
//            let create      = {self.source.favoriteViewModel.createFavorite(business: currentBusiness)}
//            let delete      = {self.source.favoriteViewModel.deleteFavorite(business: currentBusiness)}
//            isFavorite() ? create() : delete()
//            reset()
//            self.parent.tableView.reloadData()
//            myBool(true)                                //Dismiss the leading swipe from UI
//        }
//        action.image            = currentBusiness.isFavorite   ? #imageLiteral(resourceName: "cancel") : #imageLiteral(resourceName: "Favorite")
//        action.backgroundColor  = currentBusiness.isFavorite   ? .lightSteelBlue1 : .lightSteelBlue2
//        let configuration       = UISwipeActionsConfiguration(actions: [action])
//        return configuration
//    }
}

