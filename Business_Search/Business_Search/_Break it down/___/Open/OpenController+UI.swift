//
//  OpenController+UI.swift
//  Business_Search
//
//  Created by admin on 7/30/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import MapKit

extension OpenController {
    func undoBlur() {
        removeDarkScreenBlur()
        navigationController?.setNavigationBarHidden(false, animated: true)        
        doesLocationEntityExist = false //setup action inside 'readOrCreateLocation'
        readOrCreateLocation()
        animateResultsAreFilteredLabel()
    }

    
    func setupNavigationMenu(){
        let imageView = UIImageView(image: #imageLiteral(resourceName: "BUSINESS_Finder"))
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView
        troubleshootFromNavigationMenu()
        navigationItem.searchController = searchController
    }
    
    @objc func handleShowSearch(){
        searchController.isActive = true
    }
    
    func troubleshootFromNavigationMenu(){
        let searchBarButton     = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleShowSearch))
        let composeBarButton    = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(handleFilter))
        navigationItem.rightBarButtonItems = [composeBarButton, searchBarButton]
    }
    
    
    func setupUI(){
        setupNavigationMenu()
        definesPresentationContext = true
        [tableView, viewObject.nothingFoundView].forEach{view.addSubview($0)}
        viewObject.nothingFoundView.centerToSuperView()
        tableView.fillSafeSuperView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        tableView.dataSource = tableDataSource
        tableView.delegate = tableDelegate
        readOrCreateLocation()
    }
    
    func readOrCreateLocation(){                                        //Check if location exists or download
        locationViewModel.fetchLocationController = nil                 //Only time Locations should be loaded
        var index = 0
        let possibleInsertLocationCoordinate = CLLocation(latitude: latitude, longitude: longitude)
        let locationArray = locationViewModel.fetchLocationController?.fetchedObjects
        guard let _locationArray = locationArray else {return}
        if _locationArray.isEmpty {
            _ = YelpClient.getBusinesses(latitude: latitude,
                                         longitude: longitude,
                                         completion: handleGetNearbyBusinesses(inputData:result:))
            return
        }
        
        func updateCoordinates(latitude: Double, longitude: Double){
            self.latitude = latitude
            self.longitude = longitude
            coordinator?.updateCoordinate(latitude: latitude, longitude: longitude)
        }
        //While "return" can break out of the function
        while index < _locationArray.count {
            let tempLocation = CLLocation(latitude: _locationArray[index].latitude, longitude: _locationArray[index].longitude)
            let distanceBetweenInputLocationAndCurrentLoopLocation = tempLocation.distance(from: possibleInsertLocationCoordinate)
            let miles = distanceBetweenInputLocationAndCurrentLoopLocation * 0.000621371
            if miles < 0.5 {
                latitude = _locationArray[index].latitude; longitude = _locationArray[index].longitude
                updateCoordinates(latitude: latitude, longitude: longitude)
                businessViewModel.reload(lat: latitude, long: longitude)
                categoryCountViewModel.reload(lat: latitude, long: longitude)
                tableDataSource.longitude = longitude
                tableDataSource.latitude = latitude
                return                           //Exit the function
            }
            index += 1
        }
        _ = YelpClient.getBusinesses(latitude: latitude,
                                     longitude: longitude,
                                     completion: handleGetNearbyBusinesses(inputData:result:))
    }
}
