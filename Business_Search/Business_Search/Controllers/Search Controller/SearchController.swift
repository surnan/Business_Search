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
    
    func setupNavigationMenu(){
        navigationItem.searchController = searchController
        navigationItem.title = "Business Search"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "New Location", style: .done, target: self, action: #selector(getNewLocation))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete All", style: .done, target: self, action: #selector(deleteAll))
    }
    
    @objc func deleteAll(){
        do {
            let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Location")
            let request = NSBatchDeleteRequest(fetchRequest: fetch)
            try self.dataController.backGroundContext.execute(request)
            try self.dataController.backGroundContext.save()
        } catch {
            print ("There was an error deleting Locations from CoreData")
        }
    }
    
    @objc func sayHello(){
        print("Hello")
    }
    
    var urlSessionTask: URLSessionDataTask?
    var dataController: DataController!
    var myFetchController: NSFetchedResultsController<Location>!
    
    
    var locationArray = [Location]()
    
    
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.white
        setupNavigationMenu()
        definesPresentationContext = true //Keeps the navigation & search menu on screen and forces tableView underneath
        setupFetchController()
        locationArray = getAllLocations()
        if isMyLocationSaved(lat: latitude, lon: longitude) {return}
        getNewLocationData()
    }
    
    @objc func getNewLocation(){
        getNewLocationData()
    }
    
    
    func getNewLocationData() {
        _ = Yelp.loadUpBusinesses(latitude: latitude, longitude: longitude, completion: handleLoadUpBusinesses(result:))
    }
    
    
    func isMyLocationSaved(lat: Double, lon: Double)-> Bool{
        for (_, element) in locationArray.enumerated() {
            if element.latitude == lat && element.longititude == lon {
                return true //can't exit out of $0 loop prematurely
            }
        }
        return false
    }
    
    
    func getAllLocations()-> [Location]{
        return myFetchController.fetchedObjects ?? []
    }
    
     
    func connectCategoryToBusiness(businessID: NSManagedObjectID?, alias: String?, title: String?){
        guard let _businessID = businessID else {return}
        let backgroundContext: NSManagedObjectContext! = dataController.backGroundContext
        
        backgroundContext.perform {
            let backgroundBusiness = backgroundContext.object(with: _businessID) as! Business
            let tempCategory = Category(context: backgroundContext)
            tempCategory.alias = alias ?? ""
            tempCategory.title = title ?? ""
            tempCategory.business = backgroundBusiness
            do {
                try backgroundContext.save()
            } catch let saveErr {
                print("Error: Core Data Save Error when connecting Category to Business connectCategoryToBusiness(...)\nCode: \(saveErr.localizedDescription)")
                print("Full Error Details: \(saveErr)")
            }
        }
    }
    
    func handleLoadUpBusinesses(result: Result<YelpBusinessResponse, NetworkError>){ //+1
        switch result { //+2
        case .failure(let error):
            print("-->Error (localized): \(error.localizedDescription)\n-->Error (Full): \(error)")
        case .success(let data):
            print("---> Succesfully decoded data")
            print("Number of Records returned = \(data.businesses.count)")
            addLocation(data: data)
        } //-2
    } //-1
    
    
    var categoryArray = [[String]]()
    
    func addLocation(data: YelpBusinessResponse){
        let backgroundContext = dataController.backGroundContext!
        let newLocation = Location(context: backgroundContext)
        newLocation.latitude = data.region.center.latitude
        newLocation.longititude = data.region.center.longitude
        newLocation.totalBusinesses = Int32(data.total)
        newLocation.radius = Int32(radius) //AppDelegate
    
        //var categoryArray = [[String]]()
        data.businesses.forEach { (business) in
            business.categories.forEach({ (category) in
                guard let title = category.title else {return}
                print("title = \(title)")
                
                if categoryArray.isEmpty {
                    categoryArray.append([title])
                    return
                }
                
                for i in 0 ... categoryArray.count - 1 {
                    if categoryArray[i].first == title {
                        categoryArray[i].append(title)
                        break
                    } else if i == categoryArray.count - 1 {
                        categoryArray.append([title])
                        break
                    }
                }
            })
        }
        
        
        
        
        do {
            try backgroundContext.save()
            newLocation.addBusinesses(yelpData: data, dataController: dataController)
        } catch {
            print("Error saving func addLocation() --\n\(error)")
        }
    }
}
