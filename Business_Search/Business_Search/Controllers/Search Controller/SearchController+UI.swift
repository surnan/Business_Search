//
//  SearchController+UI.swift
//  Business_Search
//
//  Created by admin on 4/23/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

extension SearchController {
    func setupNavigationMenu(){
        navigationItem.searchController = searchController
        navigationItem.title = "Business Search"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "New Location", style: .done, target: self, action: #selector(handleGetNewLocation))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete All", style: .done, target: self, action: #selector(handleDeleteAll))
    }
    
    
    
    
    
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.white
        setupNavigationMenu()
        definesPresentationContext = true //Keeps the navigation & search menu on screen and forces tableView underneath
        setupFetchController()
        locationArray = getAllLocations()
        if isMyLocationSaved(lat: latitude, lon: longitude) {return}
        getNewLocationData()
    }
    
    func getAllLocations()-> [Location]{
        return myFetchController.fetchedObjects ?? []
    }
    
    func isMyLocationSaved(lat: Double, lon: Double)-> Bool{
        for (_, element) in locationArray.enumerated() {
            if element.latitude == lat && element.longititude == lon {
                return true //can't exit out of $0 loop prematurely
            }
        }
        return false
    }
    
    func getNewLocationData() {
        _ = Yelp.loadUpBusinesses(latitude: latitude, longitude: longitude, completion: handleLoadUpBusinesses(result:))
    }
    
}
