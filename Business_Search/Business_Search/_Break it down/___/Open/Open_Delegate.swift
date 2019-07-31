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

extension Open_Delegate {
    //MARK:- ROW RIGHT-SIDE ACTIONS
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let actionBusiness = UITableViewRowAction(style: .normal, title: "SHARE") {[unowned self] (action, indexPath) in
            //guard let currentBusiness = self.delegate.getModel.fetchBusinessController?.object(at: indexPath) else {return}
            guard let currentBusiness = self.source.businessViewModel.fetchBusinessController?.object(at: indexPath) else {return}
            self.shareBusiness(business: currentBusiness)
        }
        actionBusiness.backgroundColor = .darkBlue
        let actionCategory = UITableViewRowAction(style: .normal, title: "RANDOM") {[unowned self] (action, indexPath) in
            //let currentCategory = self.dataDelegate.getCategoryName(at: indexPath.row)
            let currentCategory = self.getCategoryName(at: indexPath.row)
            
            let items           = self.getBusinessesFromCategoryName(category: currentCategory)
            let modder          = items.count - 1
            let randomNumber    = Int.random(in: 0...modder)
            self.parent.coordinator?.loadBusinessDetails(currentBusiness: items[randomNumber])
        }
        actionBusiness.backgroundColor = .red
        actionCategory.backgroundColor = .blue
        return source.tableArrayType == TableIndex.category.rawValue ? [actionCategory] : [actionBusiness]
    }
    
    func getCategoryName(at index: Int) -> String {
        //let categoryName = fetchCategoryNames![index]
        let categoryName = source.categoryNameCountViewModel.fetchCategoryNames![index]
        return categoryName
    }
    
    func shareBusiness(business: Business){
        let prependText = UserDefaults.standard.object(forKey: AppConstants.greetingMessage.rawValue) as? String
            ?? "Please check this link. \n"
        guard let temp = business.url else {return}
        let items: [Any] = ["\(prependText) \(temp)"]
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        activityVC.completionWithItemsHandler = {[unowned self](activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if !completed {
                return
            }
            //self.dismiss(animated: true, completion: nil)
            self.parent.dismiss(animated: true, completion: nil)
        }
        //present(activityVC, animated: true)
        parent.present(activityVC, animated: true)
    }
}
