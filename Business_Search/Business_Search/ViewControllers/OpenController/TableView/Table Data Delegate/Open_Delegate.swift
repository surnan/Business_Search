//
//  Open_Delegate.swift
//  Business_Search
//
//  Created by admin on 7/30/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class Open_Delegate: NSObject, UITableViewDelegate, OpenControllerType {
    private var reloadCellAt: IndexPath?
    private let dataController: DataController
    private var selectedCategoryPredicate : NSPredicate?
    let coordinator: OpenCoordinator?
    let parent: OpenController
    let source: Open_DataSource
    
    var getLatitude: Double {return parent.getLatitude}
    var getLongitude: Double {return parent.getLongitude}
    
    private lazy var viewModel = CategoryViewModel(dataController: dataController,
                                                   lat: parent.getLatitude,
                                                   lon: parent.getLongitude)
    
    init(parent: OpenController, source: Open_DataSource) {
        self.parent = parent
        self.source = source
        self.coordinator = parent.coordinator
        self.dataController = parent.dataController
    }
    
    func reloadCellIfNecessary(tableView: UITableView) {
        guard let cellIndex = reloadCellAt else {return}
        tableView.reloadRows(at: [cellIndex], with: .none)
        reloadCellAt = nil
    }

    private func updateCategoryPredicate(category: String){
        selectedCategoryPredicate = NSPredicate(format: "title BEGINSWITH[cd] %@", argumentArray: [category])
        viewModel.reload()
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
        case TableIndex.business.rawValue:
            guard let currentBusiness = source.businessViewModel.objectAt(indexPath: indexPath) else {return}
            let matchingBusinesses = findMatchingNames(business: currentBusiness)
            if matchingBusinesses.count == 1 {
                parent.coordinator?.loadBusinessDetails(currentBusiness: currentBusiness)
            } else {
                parent.duplicateBusinessAlertController(business: currentBusiness, businesses: matchingBusinesses)
                //parent.coordinator?.loadTabController(businesses: matchingBusinesses, categoryName: "ABC")
            }
        case TableIndex.category.rawValue:
            let currentCategory = source.categoryNameCountViewModel.objectAt(indexPath: indexPath)
            let items = getBusinessesFromCategoryName(category: currentCategory)
            parent.coordinator?.loadTabController(businesses: items, categoryName: currentCategory)
        default:
            print("Illegal Value inside tableViewArrayType")
        }
    }
    
    
    private func findMatchingNames(business: Business) -> [Business]{
        let tempController = BusinessViewModel(delegate: self, dataController: dataController)
        tempController.search(business: business)
        let allMatchingBusinesses = tempController.fetchedObjects()
        //print("allMatchingBusinesses.count = \(allMatchingBusinesses.count)")
        return allMatchingBusinesses
    }
}
