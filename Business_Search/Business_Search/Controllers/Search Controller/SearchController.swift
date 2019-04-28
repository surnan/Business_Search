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
    //Mark: Injected
    var dataController: DataController!
    var myFetchController: NSFetchedResultsController<Location>!
    
    //MARK: Local
    var locationArray = [Location]()
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
    
    
    
    func loadCategories(data: YelpBusinessResponse){
        var index: Int
        if categories.isEmpty {
            index = -1  //index incremented by one once array initialized
        } else {
            index = businesses.count - 1
        }
        
        data.businesses.forEach { (business) in
            index += 1
            guard let title = business.name,
                let id = business.id,
                let address = business.location.address1,
                let state = business.location.city,
                let zipCode = business.location.zip_code
                else {
                    return
            }
            
            let tempBusiness = YelpBusinessElement(title: title, address: address, state: state, zipCode: zipCode, businessID: id)
            businesses.append(tempBusiness)
            business.categories.forEach({ (category) in
                guard let title = category.title, let alias = category.alias else {return}
                let temp = YelpCategoryElement(alias: alias, title: title, businessID: id)
                if categories.isEmpty {
                    categories.append([temp])
                    return
                }
                for i in 0 ... categories.count - 1 {
                    if categories[i].first == temp {
                        categories[i].append(temp)
                        break
                    } else if i == categories.count - 1 {
                        categories.append([temp])
                        break
                    }
                }
            })
        }
    }
}
