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
    
    
    
    func resetAllPredicateRelatedVar() {
        fetchBusinessPredicate = nil
        fetchCategoryArrayNamesPredicate = nil
        fetchBusinessController = nil
        fetchCategoryNames = nil
    }
    
    func setupNotificationReceiver(){
        activityView.center = view.center
        activityView.startAnimating()
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(locationFound), name: Notification.Name("GettingLocation"), object: nil)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        nc.addObserver(self, selector: #selector(locationFound), name: Notification.Name("locationFound"), object: nil)
        
        //Check if location exists
//        _ = isLocationNew()
        
        print("possibleInsertLocationCoordinate ==> \(String(describing: possibleInsertLocationCoordinate))")
        
        [tableView, activityView].forEach{view.addSubview($0)}
        nothingFoundView.center = view.center   //UILabel When tableView is empty
        view.insertSubview(nothingFoundView, aboveSubview: tableView)
        tableView.fillSuperview()
        setupNavigationMenu()
        resetAllPredicateRelatedVar()
        definesPresentationContext = true
        setupNotificationReceiver()
    }
    
    @objc func locationFound(){
        activityView.stopAnimating()
        
        if locationPassedIn {
            return
        }
        
        locationPassedIn = true
        nc.removeObserver("locationFound")
        
        fetchLocationController = nil
        if possibleInsertLocationCoordinate != nil {
            print("--> Location = \(possibleInsertLocationCoordinate.coordinate)")
            let locationArray = fetchLocationController?.fetchedObjects
            locationArray?.forEach{
                let tempLocation = CLLocation(latitude: $0.latitude, longitude: $0.longitude)
                let distanceBetweenInputLocationAndCurrentLoopLocation = tempLocation.distance(from: possibleInsertLocationCoordinate)
                let miles = distanceBetweenInputLocationAndCurrentLoopLocation * 0.000621371
                print("[\($0.latitude), \($0.longitude)]====> \(String(format: "%.2f", miles)) miles")
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    func isLocationNew()-> Bool{
        fetchLocationController = nil
        if possibleInsertLocationCoordinate != nil {
            print("--> Location = \(possibleInsertLocationCoordinate.coordinate)")
            let locationArray = fetchLocationController?.fetchedObjects
            locationArray?.forEach{
                let tempLocation = CLLocation(latitude: $0.latitude, longitude: $0.longitude)
                let distanceBetweenInputLocationAndCurrentLoopLocation = tempLocation.distance(from: possibleInsertLocationCoordinate)
                let miles = distanceBetweenInputLocationAndCurrentLoopLocation * 0.000621371
                print("Distance to [\($0.latitude), \($0.longitude)]= \(String(format: "%.2f", miles)) miles")
            }
        }
        return false
    }
    
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
        //  deleteAll()
        self.fetchBusinessController = nil
        self.fetchCategoriesController = nil
        _ = YelpClient.getNearbyBusinesses(latitude: latitude, longitude: longitude, completion: handleGetNearbyBusinesses(inputData:result:))
    }
    
    @objc func JumpToBreakPoint(total: Int){
        print("")
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
                //  context.reset()
            } catch {
                print("Error deleting All \(error)")
            }
        }
    }
}
