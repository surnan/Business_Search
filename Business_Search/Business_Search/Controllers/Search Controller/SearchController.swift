//
//  FirstController.swift
//  Business_Search
//
//  Created by admin on 4/16/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData


protocol SearchControllerProtocol {
    func getBusinesses()->[Business]
    func getCategories()->[[Category]]
}




class SearchController: UIViewController, UISearchControllerDelegate, SearchControllerProtocol{
    func getBusinesses()-> [Business] {
        return myBusinesses
    }
    
    func getCategories()-> [[Category]] {
        return myCategories
    }
    
    
    
    
    //MARK: Injected
    var dataController: DataController!
    var myFetchController: NSFetchedResultsController<Location>!
    
    var myCategories = [[Category]]()
    var myBusinesses = [Business]()
    var myLocations = [Location]()
    var currentLocation: Location!
    var doesLocationExist = false
    
    //MARK: Local
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
    
    
    func getCurrentLocation()->[Location]{
        //The whole setupFetchedResultsController was for this line
        return myFetchController.fetchedObjects ?? []
    }
    
    
    func loadBusinessArray(){
        myBusinesses = (currentLocation.businesses?.toArray())!
    }
    
    func convertBusinessToCategories(){ //+1
        myBusinesses.forEach { (currentBusiness) in     //+2
            let categoriesOnThisBusiness: [Category] = (currentBusiness.categories?.toArray())!
            categoriesOnThisBusiness.forEach({ (currentCategory) in     //+3
                if let index = myCategories.indexOfFirstItemMatching(category: currentCategory) {
                    myCategories[index].append(currentCategory)
                } else {
                    myCategories.append([currentCategory])
                }
            })      //-3
        }       //-2
    }       //-1
}

extension NSSet {
    func toArray<T>() -> [T] {
        let array = self.map({ $0 as! T})
        return array
    }
}

