//
//  FirstController.swift
//  Business_Search
//
//  Created by admin on 4/16/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData


class SearchController: UIViewController, UISearchControllerDelegate{
    //MARK: Injected
    var dataController: DataController!
    var myFetchController: NSFetchedResultsController<Location>!
    
    //MARK: Local
    var categories = [[YelpCategoryElement]]()
    var businesses = [YelpBusinessElement]()
    var currentLocationID: NSManagedObjectID?
    var urlSessionTask: URLSessionDataTask?
    var urlsQueue = [YelpGetNearbyBusinessStruct]() //enumeration loop for semaphores
    let resultsTableController = ResultsController()
    //var resultsTableController: ResultsTableViewController? //Can't make it work
    
    
    lazy var searchController: UISearchController = {
        var search = UISearchController(searchResultsController: resultsTableController)
        search.delegate = self
        search.searchResultsUpdater = resultsTableController
        search.searchBar.delegate = resultsTableController
        search.searchBar.placeholder = "Search place"
        search.searchBar.barTintColor = navigationController?.navigationBar.barTintColor
        search.searchBar.tintColor = self.view.tintColor
        search.searchBar.scopeButtonTitles = ["Business Names", "Categories"]
        search.searchBar.barStyle = .black      // TyLocationg Font = white
        //search.obscuresBackgroundDuringPresentation = true    //removes .lightContent from navigation item
        //DON'T SEE IT
        //        search.searchBar.sizeToFit()
        //        search.dimsBackgroundDuringPresentation = true
        //        search.loadViewIfNeeded()
        //        search.hidesNavigationBarDuringPresentation = false
        //        search.searchBar.barTintColor = UIColor.orange
        return search
    }()
    
    
    
    func loadCategoriesAndBusinesses(data: YelpBusinessResponse){
        var index: Int
        if categories.isEmpty {
            index = -1  //index incremented by one once array initialized
        } else {
            index = businesses.count - 1
        }
        
        data.businesses.forEach { (currentBusiness) in
            businesses.append(YelpBusinessElement(title: currentBusiness.name ?? "",
                                                  address: currentBusiness.location.display_address.first ?? "",
                                                  state: currentBusiness.location.state ?? "",
                                                  zipCode: currentBusiness.location.zip_code ?? "",
                                                  businessID: currentBusiness.id ?? ""))
            index += 1
            currentBusiness.categories.forEach({ (currentCategory) in
                let newCategory = YelpCategoryElement(alias: currentCategory.alias ?? "", title: currentCategory.title ?? "", businessID: currentBusiness.id ?? "")
                if categories.isEmpty {
                    categories.append([newCategory])
                    return
                }
                for i in 0 ... categories.count - 1 {
                    if categories[i].first == newCategory {
                        categories[i].append(newCategory)
                        break
                    } else if i == categories.count - 1 {
                        categories.append([newCategory])
                        break
                    }
                }
            })
        }
    }
}
