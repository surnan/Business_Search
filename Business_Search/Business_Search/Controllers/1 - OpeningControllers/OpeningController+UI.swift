//
//  OpeningController+UI.swift
//  Business_Search
//
//  Created by admin on 5/9/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData
import MapKit


extension OpeningController {
    
    //MARK:- ViewDidLoad()
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent                                                                //Status bar sometimes turns black when typing into search bar
    }                                                                                       //Setting color scheme here just to play it safe
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        noGPS()
    }
    
    func setupUI(){
        [tableView, activityView].forEach{view.addSubview($0)}
        nothingFoundView.center = view.center                                               //UILabel When tableView is empty
        view.insertSubview(nothingFoundView, aboveSubview: tableView)
        tableView.fillSuperview()
        setupNavigationMenu()
        definesPresentationContext = true
    }
    
    func noGPS(){  //Check if location exists or download
        fetchLocationController = nil                                                       //Only time Locations should be loaded
        let locationArray = fetchLocationController?.fetchedObjects
        guard let _locationArray = locationArray else {return}
        if _locationArray.isEmpty {
            _ = YelpClient.getBusinesses(latitude: latitude, longitude: longitude, completion: handleGetNearbyBusinesses(inputData:result:))
            return
        }
        
        var index = 0
        let possibleInsertLocationCoordinate = CLLocation(latitude: latitude, longitude: longitude)
        
        //While Loop so the return can break out of the function with 'return'
        while index < _locationArray.count {    //+1
            let tempLocation = CLLocation(latitude: _locationArray[index].latitude, longitude: _locationArray[index].longitude)
            let distanceBetweenInputLocationAndCurrentLoopLocation = tempLocation.distance(from: possibleInsertLocationCoordinate)
            let miles = distanceBetweenInputLocationAndCurrentLoopLocation * 0.000621371
            
            if miles < 1.0 {   //+2
                latitude = _locationArray[index].latitude; longitude = _locationArray[index].longitude
                fetchBusinessController = nil
                tableView.reloadData()
                return                                                                      //Exit the function
            }   //-2
            index += 1
        }   //-1
        _ = YelpClient.getBusinesses(latitude: latitude, longitude: longitude, completion: handleGetNearbyBusinesses(inputData:result:))
    }
    
    //MARK:- Navigation Menu
    func setupNavigationMenu(){
        let logo = UIImage(imageLiteralResourceName: "Inline-Logo")
        let imageView = UIImageView(image: logo)
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView
        navigationItem.searchController = searchController
        navigationItem.leftBarButtonItems = [UIBarButtonItem(title: "←", style: .done, target: self, action: #selector(handleBack)),
                                             UIBarButtonItem(title: "▶️", style: .done, target: self, action: #selector(handleDownloadBusinesses)),
                                             UIBarButtonItem(title: " ⏸", style: .done, target: self, action: #selector(JumpToBreakPoint))]
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete All", style: .done, target: self, action: #selector(handleDeleteAll))
    }
    
    @objc func handleBack(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleDownloadBusinesses(){
        //  1 - Delete all existing data in Core Data and run Yelp.xxx to re-download everything for (latitude/longitude)
        deleteAll()
        self.fetchBusinessController = nil
        self.fetchCategoriesController = nil
        //  -1
        _ = YelpClient.getBusinesses(latitude: latitude, longitude: longitude, completion: handleGetNearbyBusinesses(inputData:result:))
    }
    
    @objc func handleDeleteAll() {deleteAll() }
    
    func deleteAll(){
        let context: NSManagedObjectContext!  = dataController.backGroundContext
        context.perform {
            let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Location")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetch)
            do {
                _  = try context.execute(deleteRequest) as! NSBatchDeleteResult
                self.fetchBusinessController = nil
                self.fetchCategoriesController = nil
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print("Error deleting All \(error)")
            }
        }
    }
    
    
    
    //MARK:- BreakPoint
    @objc func JumpToBreakPoint(total: Int){
        print("fetchBusiness.FetchedObject.count - ", fetchBusinessController?.fetchedObjects?.count ?? -999)
        print("fetchCategoryArray.count - ", fetchCategoryNames?.count ?? -999)

        //FetchController Reset NOT predicate reset
        fetchLocationController = nil
        fetchBusinessController = nil
        fetchCategoriesController = nil
        fetchCategoryNames = nil
        tableView.reloadData()
    }
}
