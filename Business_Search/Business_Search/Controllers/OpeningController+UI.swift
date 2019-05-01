//
//  OpeningController+UI.swift
//  Business_Search
//
//  Created by admin on 5/1/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData

extension OpeningController {
    func setupNavigationMenu(){
        navigationItem.searchController = searchController
        navigationItem.title = "🔷 Business 🔷"
        navigationItem.leftBarButtonItems = [UIBarButtonItem(title: "▶️", style: .done, target: self, action: #selector(handleDownloadBusinesses)), UIBarButtonItem(title: " ⏸ ", style: .done, target: self, action: #selector(JumpToBreakPoint))]
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete All", style: .done, target: self, action: #selector(handleDeleteAll))
    }
    
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.white
        resultsTableController.dataController = dataController
        
        setupNavigationMenu()
        definesPresentationContext = true //Keeps the navigation & search menu on screen and forces tableView underneath
        setupFetchController()
        myFetchController.delegate = self
        guard let firstLocation = getCurrentLocation().first else {
            print("This Location is not in Core Data")
            return
        }
        
        currentLocation = firstLocation //hard-coding latitude & longitude
        loadBusinessArray()
        let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { [weak self] timer in
            self?.convertBusinessToCategories()
        }
        timer.fire()
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
    }
    
    //MARK:- Below is Bar Button functions or Called in ViewDidLoad()
    @objc func handleDeleteAll(){
        myBusinesses.removeAll()
        myCategories.removeAll()
        doesLocationExist = false
        
        let context: NSManagedObjectContext!  = dataController.backGroundContext
        
        context.perform {
            let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Location")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetch)
            
            do {
                _  = try context.execute(deleteRequest) as! NSBatchDeleteResult
                //  context.reset()
            } catch {
                print("Error deleting All \(error)")
            }
        }
    }
}
