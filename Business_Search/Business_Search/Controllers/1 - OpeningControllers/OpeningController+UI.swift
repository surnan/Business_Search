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


//var currentLatitude: Double = 0.0
//var currentLongitude: Double = 0.0


extension OpeningController {
    
    //MARK:- ViewDidLoad()
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent       //Status bar sometimes turns black when typing into search bar
    }                              //Setting color scheme here just to play it safe
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        readOrCreateLocation()
        setupNavigationMenu()
    }
    
    func setupUI(){
        [tableView].forEach{view.addSubview($0)}
        nothingFoundView.center = view.center                               //UILabel When tableView is empty
        view.insertSubview(nothingFoundView, aboveSubview: tableView)
        tableView.fillSafeSuperView()
        view.backgroundColor = .lightRed
        //tableView.fillSuperview()
        //setupNavigationMenu()
        definesPresentationContext = true
    }
    
    func readOrCreateLocation(){  //Check if location exists or download
        fetchLocationController = nil                                       //Only time Locations should be loaded
        let locationArray = fetchLocationController?.fetchedObjects
        guard let _locationArray = locationArray else {return}
        if _locationArray.isEmpty {
            _ = YelpClient.getBusinesses(latitude: latitude,
                                         longitude: longitude,
                                         completion: handleGetNearbyBusinesses(inputData:result:))
            return
        }
        
        var index = 0
        let possibleInsertLocationCoordinate = CLLocation(latitude: latitude, longitude: longitude)
        
        //While Loop so the return can break out of the function with 'return'
        while index < _locationArray.count {
            let tempLocation = CLLocation(latitude: _locationArray[index].latitude, longitude: _locationArray[index].longitude)
            let distanceBetweenInputLocationAndCurrentLoopLocation = tempLocation.distance(from: possibleInsertLocationCoordinate)
            let miles = distanceBetweenInputLocationAndCurrentLoopLocation * 0.000621371
            
            if miles < 1.0 {
                latitude = _locationArray[index].latitude; longitude = _locationArray[index].longitude
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
        navigationItem.rightBarButtonItems = [UIBarButtonItem(title: " ⏸", style: .done, target: self, action: #selector(JumpToBreakPoint))]
    }
    
    
    //MARK:- BreakPoint
    @objc func JumpToBreakPoint(total: Int){
        print("Radius = \(radius)")
        print("fetchBusiness.FetchedObject.count - ", fetchBusinessController?.fetchedObjects?.count ?? -999)
        print("fetchCategoryArray.count - ", fetchCategoryNames?.count ?? -999)
        print("START -> dest -> lat = \(latitude ?? -999) ... lon = \(longitude ?? -999)")
    }
}
