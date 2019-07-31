//
//  Open_Delegate.swift
//  Business_Search
//
//  Created by admin on 7/30/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class Open_Delegate: NSObject, UITableViewDelegate {
    private let coordinator: SearchTableCoordinator?
    let parent: OpenController
    let source: Open_DataSource
    private var reloadCellAt: IndexPath?
    private let latitude: Double
    private let longitude: Double
    private let dataController: DataController
    private var selectedCategoryPredicate : NSPredicate?
    private lazy var viewModel = CategoryViewModel(dataController: dataController,
                                                   lat: latitude,
                                                   lon: longitude)
    
    init(parent: OpenController, source: Open_DataSource) {
        self.parent = parent
        self.source = source
        self.coordinator = parent.coordinator
        self.latitude = parent.latitude
        self.longitude = parent.longitude
        self.dataController = parent.dataController
    }
    
    private func reloadCellIfNecessary(tableView: UITableView) {
        guard let cellIndex = reloadCellAt else {return}
        tableView.reloadRows(at: [cellIndex], with: .none)
        reloadCellAt = nil
    }
    
    
    private func updateCategoryPredicate(category: String){
        selectedCategoryPredicate = NSPredicate(format: "title BEGINSWITH[cd] %@", argumentArray: [category])
        viewModel.fetchCategoriesController = nil
    }
    
    
    func getBusinessesFromCategoryName(category: String)-> [Business]{  //NOT shown in this tableView.
        var businessArray = [Business]()    //Pushed into next ViewController
        viewModel.search(search: category)
        viewModel.allObjects.forEach{
            if let business = $0.business {businessArray.append(business)}}
        return businessArray
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        reloadCellAt = indexPath
        switch source.tableArrayType {
        case TableIndex.category.rawValue:
            guard let currentCategory = source.categoryNameCountViewModel.fetchCategoryNames?[indexPath.row] else {return}
            let items = getBusinessesFromCategoryName(category: currentCategory)
            parent.coordinator?.loadTabController(businesses: items, categoryName: currentCategory)
        case TableIndex.business.rawValue:
            guard let currentBusiness = source.businessViewModel.fetchBusinessController?.object(at: indexPath) else {return}
            parent.coordinator?.loadBusinessDetails(currentBusiness: currentBusiness)
        default:
            print("Illegal Value inside tableViewArrayType")
        }
    }
}


/*
extension Open_Delegate {
    //MARK:- ROW LEFT-SIDE ACTIONS
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //if delegate.getModel.tableViewArrayType == TableIndex.category.rawValue {return nil}
        if source.tableArrayType == TableIndex.category.rawValue {return nil}
        
        
        //let currentBusiness = dataDelegate.getBusiness(at: indexPath)
        guard let currentBusiness = source.businessViewModel.fetchBusinessController?.object(at: indexPath) else {return nil}
        
        
        let action = UIContextualAction(style: .normal, title: "Favorite") { [weak self] (action, view, myBool) in
            guard let self  = self, let dd = self.dataDelegate, let delegate = self.delegate else {return}
            let isFavorite  = delegate.updateBusinessIsFavorite(business: currentBusiness)
            isFavorite ? delegate.createFavorite(business: currentBusiness)
                :delegate.deleteFavorite(business: currentBusiness)
            dd.resetBusinessController()
            delegate.reloadData()
            myBool(true)                                //Dismiss the leading swipe from UI
        }
        action.image            = currentBusiness.isFavorite    ?  #imageLiteral(resourceName: "cancel") : #imageLiteral(resourceName: "Favorite")
        action.backgroundColor  =  currentBusiness.isFavorite   ? .lightSteelBlue1 : .orange
        let configuration       = UISwipeActionsConfiguration(actions: [action])
        return configuration
    }
}
*/
