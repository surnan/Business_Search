//
//  SearchController+UI.swift
//  Business_Search
//
//  Created by admin on 4/23/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData

extension SearchController {
    func setupNavigationMenu(){
        navigationItem.searchController = searchController
        navigationItem.title = "🔷 Business 🔷"
        navigationItem.leftBarButtonItems = [UIBarButtonItem(title: "▶️", style: .done, target: self, action: #selector(handleDownloadBusinesses)), UIBarButtonItem(title: " ⏸ ", style: .done, target: self, action: #selector(JumpToBreakPoint))]
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete All", style: .done, target: self, action: #selector(handleDeleteAll))
    }
    

    override func viewDidLoad() {
        view.backgroundColor = UIColor.white
        setupNavigationMenu()
        definesPresentationContext = true //Keeps the navigation & search menu on screen and forces tableView underneath
        setupFetchController()
        myFetchController.delegate = self
        // fetchDataToMakeBusinessArray()
        fetchDataToMakeBusinessArray2()
    }
    
    
    
    //var myBusinesses = [Business]()
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

    
    @objc func handleDownloadBusinesses(){
        _ = YelpClient.getNearbyBusinesses(latitude: latitude, longitude: longitude, completion: handleLoadBusinesses(inputData:result:))
    }
    
    @objc func JumpToBreakPoint(total: Int){
        print("")
    }
    
    //MARK:- Below is Bar Button functions or Called in ViewDidLoad()
    @objc func handleDeleteAll(){
        do {
            businesses.removeAll()
            categories.removeAll()
            let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Location")
            let request = NSBatchDeleteRequest(fetchRequest: fetch)
            try self.dataController.backGroundContext.execute(request)
            try self.dataController.backGroundContext.save()
        } catch {
            print ("There was an error deleting Locations from CoreData")
        }
    }
}
