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
    
    //MARK:- Notification Center
    func setupNotificationReceiver(){
        activityView.center = view.center
        activityView.startAnimating()
        NotificationCenter.default.addObserver(self, selector: #selector(locationFound), name: Notification.Name("locationFound"), object: nil)
        //print("possibleInsertLocationCoordinate ==> \(String(describing: possibleInsertLocationCoordinate))")
    }
    
    @objc func locationFound(){
        activityView.stopAnimating()
        if let _ = delegate {
            fromNearbySearch()
            return
        }
    }
    
    func fromNearbySearch(){  //Push directly from MenuController
        guard let tempPossibleInsertLocationCoordinate = delegate?.getUserLocation() else { return }
        possibleInsertLocationCoordinate = tempPossibleInsertLocationCoordinate
        
        let coord = possibleInsertLocationCoordinate.coordinate
        currentLatitude = coord.latitude; currentLongitude = coord.longitude

        delegate?.stopGPS()
        //print("possibleInsertLocationCoordinate ----> \(String(describing: possibleInsertLocationCoordinate))")
        fetchLocationController = nil   //locations only reset here in this app
        if possibleInsertLocationCoordinate != nil {
            let locationArray = fetchLocationController?.fetchedObjects
            let coord = possibleInsertLocationCoordinate.coordinate
            if locationArray!.isEmpty && !locationPassedIn{
                locationPassedIn = true
                _ = YelpClient.getBusinesses(latitude: coord.latitude, longitude: coord.longitude, completion: handleGetNearbyBusinesses(inputData:result:))
                return
            }
            locationArray?.forEach{
                let tempLocation = CLLocation(latitude: $0.latitude, longitude: $0.longitude)
                let distanceBetweenInputLocationAndCurrentLoopLocation = tempLocation.distance(from: possibleInsertLocationCoordinate)
                let miles = distanceBetweenInputLocationAndCurrentLoopLocation * 0.000621371
                //print("[\($0.latitude), \($0.longitude)]====> \(String(format: "%.2f", miles)) miles")
            }
        }
    }
    
    
    //MARK:- ViewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        [tableView, activityView].forEach{view.addSubview($0)}
        nothingFoundView.center = view.center   //UILabel When tableView is empty
        view.insertSubview(nothingFoundView, aboveSubview: tableView)
        tableView.fillSuperview()
        setupNavigationMenu()
        fetchAllNoPredicate()
        definesPresentationContext = true
        setupNotificationReceiver()
        
        //Check if previous controller is MenuController()
        if let _ = possibleInsertLocationCoordinate {
            noGPS()
        }
    }
    
    func noGPS(){   //Push by SearchByMapController
        activityView.stopAnimating()
        let coord = possibleInsertLocationCoordinate.coordinate
        currentLatitude = coord.latitude; currentLongitude = coord.longitude
        

        fetchLocationController = nil   //locations only reset here in this app
        if possibleInsertLocationCoordinate != nil {
            let locationArray = fetchLocationController?.fetchedObjects
            
            if locationArray!.isEmpty && !locationPassedIn{
                locationPassedIn = true
                _ = YelpClient.getBusinesses(latitude: coord.latitude, longitude: coord.longitude, completion: handleGetNearbyBusinesses(inputData:result:))
                return
            }
            
            guard locationArray != nil else {
                print("empty Location Array & possibleInsertLocationCoordinate = NIL")
                return
            }
            
            locationArray?.forEach{
                let tempLocation = CLLocation(latitude: $0.latitude, longitude: $0.longitude)
                let distanceBetweenInputLocationAndCurrentLoopLocation = tempLocation.distance(from: possibleInsertLocationCoordinate)
                let miles = distanceBetweenInputLocationAndCurrentLoopLocation * 0.000621371
                
                //print("[\($0.latitude), \($0.longitude)]====> \(String(format: "%.2f", miles)) miles")
                if miles < 1.0 {
                    print("---> Inside miles if-statement")
                    
                    //  fetchBusinessPredicate = NSPredicate(format: "name CONTAINS[cd] %@", argumentArray: [searchController.searchBar.text!])
                    //  fetchCategoryArrayNamesPredicate = NSPredicate(format: "title CONTAINS[cd] %@", argumentArray: [searchController.searchBar.text!])

                    let parentLatitude = #keyPath(Business.parentLocation.latitude)
                    let parentLongitude = #keyPath(Business.parentLocation.longitude)
                    
                    fetchBusinessPredicate = NSPredicate(format: "(\(parentLatitude) == %@) AND (\(parentLongitude) == %@)" , argumentArray: [$0.latitude, $0.longitude])
                    fetchAllNoPredicate()
                    return
                }
            }
            //This is a new LOCATION
            _ = YelpClient.getBusinesses(latitude: coord.latitude, longitude: coord.longitude, completion: handleGetNearbyBusinesses(inputData:result:))
        }
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
    
    @objc func JumpToBreakPoint(total: Int){
        print("")
        tableView.reloadData()
        print("fetchBusiness.FetchedObject.count - ", fetchBusinessController?.fetchedObjects?.count ?? -999)
        print("fetchCategoryArray.count - ", fetchCategoryNames?.count ?? -999)
    }
    
    //MARK:- Below is Bar Button functions or Called in ViewDidLoad()
    @objc func handleDeleteAll(){
        deleteAll()
    }
    
    func deleteAll(){
        doesLocationEntityExist = false
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
    
}
