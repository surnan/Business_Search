//
//  FirstController.swift
//  Business_Search
//
//  Created by admin on 4/16/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData


class SearchController: UIViewController, UISearchControllerDelegate, NSFetchedResultsControllerDelegate{
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
        loadCategoryArray()
    }
    
    func loadCategoryArray(){
        myBusinesses.forEach { (currentBusiness) in
            let categoriesOnThisBusiness: [Category] = (currentBusiness.categories?.toArray())!
            categoriesOnThisBusiness.forEach({ (currentCategory) in
                
                if myCategories.isEmpty {
                    myCategories.append([currentCategory])
                    return
                }
                
                for i in 0 ..< myCategories.count {
                    let doesItMatch = (myCategories[i].first?.matches(rhs: currentCategory))!
                    if doesItMatch {
                        myCategories[i].append(currentCategory)
                    } else if i == myCategories.count - 1 {
                        myCategories.append([currentCategory])
                    }
                }
            })
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func convertBusinessToCategories(){
         var totalIndex = 0
        myBusinesses.forEach { (currentBusiness) in
            let categoriesOnThisBusiness: [Category] = (currentBusiness.categories?.toArray())!
            categoriesOnThisBusiness.forEach({ (currentCategory) in
                
                if myCategories.isEmpty {
                    myCategories.append([currentCategory])
                    return
                }
                
                for i in 0 ..< myCategories.count {
                    totalIndex += 1
                    let doesItMatch = (myCategories[i].first?.matches(rhs: currentCategory))!
                    if doesItMatch {
                        myCategories[i].append(currentCategory)
                        break
                    } else if i == myCategories.count - 1 {
                        myCategories.append([currentCategory])
                    }
                }
            })
        }
    }


    func fetchDataToMakeBusinessArray2(){
        let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
        let predicate = NSPredicate(format: "(longitude == %@) AND (latitude == %@)", argumentArray: [longitude, latitude])
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "totalBusinesses", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            myLocations = try dataController.backGroundContext.fetch(fetchRequest)
            myLocations.first?.businesses?.forEach{
                myBusinesses.append($0 as! Business)
            }
        } catch {
            print("Error = \(error)")
        }
    }
}

extension NSSet {
    func toArray<T>() -> [T] {
        let array = self.map({ $0 as! T})
        return array
    }
}

