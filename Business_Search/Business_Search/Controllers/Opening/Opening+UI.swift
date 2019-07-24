//
//  OpeningController+UI.swift
//  Business_Search
//
//  Created by admin on 5/9/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import MapKit

extension OpeningController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent       //Status bar sometimes turns black when typing into search bar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateResultsAreFilteredLabel()
        tableDelegate.reloadCellIfNecessary(tableView: model.tableView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        readOrCreateLocation()
        setupNavigationMenu()
        model.tableView.delegate      = tableDelegate
        model.tableView.dataSource    = tableDataSource
    }
    
    func setupUI(){
        view.backgroundColor = .lightRed
        definesPresentationContext = true
        [model.tableView, model.nothingFoundView].forEach{view.addSubview($0)}
        model.tableView.fillSafeSuperView()
        model.nothingFoundView.centerToSuperView()                                      //UILabel When tableView is empty
    }
    
    func readOrCreateLocation(){  //Check if location exists or download
        tableDataSource.fetchLocationController = nil                                    //Only time Locations should be loaded
        var index = 0
        let possibleInsertLocationCoordinate = CLLocation(latitude: latitude, longitude: longitude)
        let locationArray = tableDataSource.fetchLocationController?.fetchedObjects
        guard let _locationArray = locationArray else {return}
        if _locationArray.isEmpty {
            _ = YelpClient.getBusinesses(latitude: latitude,
                                         longitude: longitude,
                                         completion: handleGetNearbyBusinesses(inputData:result:))
            return
        }
        //While "return" can break out of the function
        while index < _locationArray.count {
            let tempLocation = CLLocation(latitude: _locationArray[index].latitude, longitude: _locationArray[index].longitude)
            let distanceBetweenInputLocationAndCurrentLoopLocation = tempLocation.distance(from: possibleInsertLocationCoordinate)
            let miles = distanceBetweenInputLocationAndCurrentLoopLocation * 0.000621371
            if miles < 0.5 {
                latitude = _locationArray[index].latitude; longitude = _locationArray[index].longitude
                tableDataSource.updateCoordinates(latitude: latitude, longitude: longitude)
                reloadFetchControllers()
                return                           //Exit the function
            }
            index += 1
        }
        _ = YelpClient.getBusinesses(latitude: latitude,
                                     longitude: longitude,
                                     completion: handleGetNearbyBusinesses(inputData:result:))
    }
    
    //MARK:- Navigation Menu
    func setupNavigationMenu(){
        let imageView = UIImageView(image: #imageLiteral(resourceName: "BUSINESS_Finder"))
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView
        troubleshootFromNavigationMenu()
        navigationItem.searchController = searchController
    }
    
    func troubleshootFromNavigationMenu(){
        navigationItem.rightBarButtonItems = [UIBarButtonItem(title: " ⏸", style: .done, target: self, action: #selector(JumpToBreakPoint)),
                                              UIBarButtonItem(image: #imageLiteral(resourceName: "filter2"), style: .plain, target: self, action: #selector(handleFilter))]
    }
}
