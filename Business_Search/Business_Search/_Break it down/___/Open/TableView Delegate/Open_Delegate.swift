//
//  Open_Delegate.swift
//  Business_Search
//
//  Created by admin on 7/30/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class Open_Delegate: NSObject, UITableViewDelegate {
    let coordinator: OpenCoordinator?
    let parent: OpenController
    let source: Open_DataSource
    private var reloadCellAt: IndexPath?
    let dataController: DataController
    private var selectedCategoryPredicate : NSPredicate?
    
    private lazy var viewModel = CategoryViewModel(dataController: dataController,
                                                   lat: parent.getLatitude,
                                                   lon: parent.getLongitude)
    
    
    init(parent: OpenController, source: Open_DataSource) {
        self.parent = parent
        self.source = source
        self.coordinator = parent.coordinator
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
            //guard let currentCategory = source.categoryNameCountViewModel.fetchCategoryNames?[indexPath.row] else {return}
            let currentCategory = source.categoryNameCountViewModel.objectAt(indexPath: indexPath)
            
            let items = getBusinessesFromCategoryName(category: currentCategory)
            parent.coordinator?.loadTabController(businesses: items, categoryName: currentCategory)
        case TableIndex.business.rawValue:
            let currentBusiness = source.businessViewModel.objectAt(indexPath: indexPath)
            parent.coordinator?.loadBusinessDetails(currentBusiness: currentBusiness)
        default:
            print("Illegal Value inside tableViewArrayType")
        }
    }
}
