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
    private let parent: OpenController
    private let source: Open_DataSource
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
    
    
    private func getBusinessesFromCategoryName(category: String)-> [Business]{  //NOT shown in this tableView.
        viewModel.search(search: category)
        var businessArray = [Business]()    //Pushed into next ViewController
        
        //viewModel.fetchCategoriesController?.fetchedObjects?.forEach{businessArray.append($0.business!)}
         viewModel.allObjects.forEach{
            if let business = $0.business {
                businessArray.append(business)
            }
        }
        
        return businessArray
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        reloadCellAt = indexPath
        switch source.tableArrayType {
        case TableIndex.category.rawValue:
            guard let currentCategory = source.categoryViewModel.fetchCategoryNames?[indexPath.row] else {return}
            let items = getBusinessesFromCategoryName(category: currentCategory)
            coordinator?.loadTabController(businesses: items, categoryName: currentCategory)
        case TableIndex.business.rawValue:
            guard let currentBusiness = source.businessViewModel.fetchBusinessController?.object(at: indexPath) else {return}
            coordinator?.loadBusinessDetails(currentBusiness: currentBusiness)
        default:
            print("Illegal Value inside tableViewArrayType")
        }
    }
}

