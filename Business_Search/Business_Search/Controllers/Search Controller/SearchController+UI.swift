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
        
        
        guard let firstLocation = getCurrentLocation().first else {
            print("This Location is not in Core Data")
            return
        }
        
        currentLocation = firstLocation
        loadBusinessArray()
//        fetchDataToMakeBusinessArray2()
//        convertBusinessToCategories()
    }
    
    @objc func handleDownloadBusinesses(){
        myBusinesses.removeAll()
        myCategories.removeAll()
        _ = YelpClient.getNearbyBusinesses(latitude: latitude, longitude: longitude, completion: handleLoadBusinesses(inputData:result:))
    }
    
    @objc func JumpToBreakPoint(total: Int){
        print("")
        print("myBusinesses.count - ", myBusinesses.count)
        print("myCategories.count - ", myCategories.count)
        
        print("======")
        myCategories.forEach { (catArray) in
            print(catArray.first?.title ?? "", catArray.count)
        }
        
        
    }
    
    //MARK:- Below is Bar Button functions or Called in ViewDidLoad()
    @objc func handleDeleteAll(){
        do {
            myBusinesses.removeAll()
            myCategories.removeAll()
            let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Location")
            let request = NSBatchDeleteRequest(fetchRequest: fetch)
            try self.dataController.backGroundContext.execute(request)
            try self.dataController.backGroundContext.save()
        } catch {
            print ("There was an error deleting Locations from CoreData")
        }
    }
}
