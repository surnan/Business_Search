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
        
        dataController.viewContext.perform {
            let internalViewContext = self.dataController.viewContext
            let newLocation = Location(context: internalViewContext)
            newLocation.latitude = latitude
            newLocation.longititude = longitude
            
            do {
                try internalViewContext.save()
                _ = Yelp.loadUpBusinesses(locationID: newLocation.objectID, latitude: latitude, longitude: longitude,
                                          completion: self.handleLoadUpBusinesses(locationID:result:))
            } catch {
                print("Error in getNewLocationData() \n\(error)")
            }
        }
        
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
    
    func handleLoadUpBusinesses(locationID: NSManagedObjectID, result: Result<YelpBusinessResponse, NetworkError>){ //+1
        switch result { //+2
        case .failure(let error):
            print("-->Error (localized): \(error.localizedDescription)\n-->Error (Full): \(error)")
        case .success(let data):
            print("---> Succesfully decoded data")
            print("Number of Records returned = \(data.businesses.count)")
            
            let context = dataController.viewContext
            
            
//            for (_,currentBusiness) in data.businesses.enumerated() {//+2.5
                context.perform { //+3
                    let newBusiness = Business(context: self.dataController.viewContext)
                    newBusiness.fromJSON(locationID: locationID, yelpData: data, dataController: self.dataController)
                    do {    //+4
                        try self.dataController.viewContext.save()
                    } catch let saveErr { //+4.1
                        print("Error: Core Data Save Error when adding New Business.\nCode: \(saveErr.localizedDescription)")
                        print("Full Error Details: \(saveErr)")
                    } //-4.1
                } //-3
//            } //2.5
        } //-2
    } //-1
}
