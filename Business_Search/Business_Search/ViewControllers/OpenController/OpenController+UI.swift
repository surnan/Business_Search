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
        reloadFetchControllers()
        setupNavigationMenu()
    }

    @objc func handleShowSearch(){searchController.isActive = true}
    
    func setupUI(){
        setupNavigationMenu()
        definesPresentationContext = true
        let redView = viewObject.redView
        let nothingFoundView = viewObject.nothingFoundView
        [tableView, nothingFoundView, redView].forEach{view.addSubview($0)}
        nothingFoundView.centerToSuperView()
        tableView.fillSafeSuperView()
        
        NSLayoutConstraint.activate([
            redView.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            redView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            redView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            redView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        tableView.dataSource = tableDataSource
        tableView.delegate = tableDelegate
        readOrCreateLocation()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    
    @objc func keyboardWillShow(notification:NSNotification) {
        tableView.alpha = 0.5
    }
     
    @objc func keyboardWillHide(notification:NSNotification) {
        searchController.searchBar.text = tempStringForSearchField
        tableView.alpha = 1
    }
    
    
    func readOrCreateLocation(){                                        //Check if location exists or download
        locationViewModel.reload()                                      //Only time Locations should be loaded
        var index = 0
        let possibleInsertLocationCoordinate = CLLocation(latitude: getLatitude, longitude: getLongitude)
        
        let locationArray = locationViewModel.getObjects()
        if locationArray.isEmpty {
            playAnimation()
            _ = YelpClient.getBusinesses(latitude: getLatitude,
                                         longitude: getLongitude,
                                         completion: handleGetNearbyBusinesses(inputData:result:))
            return
        }
        
        func updateCoordinates(latitude: Double, longitude: Double){
            self.updateCoordinate(lat: latitude, lon: longitude)
            coordinator?.updateCoordinate(latitude: latitude, longitude: longitude)
        }
        //While "return" can break out of the function
        while index < locationArray.count {
            let tempLocation = CLLocation(latitude: locationArray[index].latitude, longitude: locationArray[index].longitude)
            let distanceBetweenInputLocationAndCurrentLoopLocation = tempLocation.distance(from: possibleInsertLocationCoordinate)
            let miles = distanceBetweenInputLocationAndCurrentLoopLocation * 0.000621371
            if miles < 0.5 {
                let lat = locationArray[index].latitude; let lon = locationArray[index].longitude
                updateCoordinates(latitude: lat, longitude: lon)
                updateCoordinates(latitude: getLatitude, longitude: getLongitude)
                businessViewModel.reload()
                categoryCountViewModel.reload()
                return                           //Exit the function
            }
            index += 1
        }
        playAnimation()
        _ = YelpClient.getBusinesses(latitude: getLatitude,
                                     longitude: getLongitude,
                                     completion: handleGetNearbyBusinesses(inputData:result:))
    }
    
    //MARK:- Setting up Right Bar Button
    func setupNavigationMenu(){
        let imageView = UIImageView(image: #imageLiteral(resourceName: "BUSINESS_Finder"))
        imageView.contentMode           = .scaleAspectFit
        self.navigationItem.titleView   = imageView
        let searchBarButton     = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleShowSearch))
        let filterBarButton     = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleFilter))
        
        navigationItem.rightBarButtonItems = [filterBarButton, searchBarButton]
        navigationItem.searchController = searchController
    }
    
//    private func getFilterBarButton()-> UIBarButtonItem {
//        if !UserAppliedFilter.shared.isFilterOn {
//            return UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(handleFilter))
//        } else {
//            return UIBarButtonItem(title: "Filtered", style: .plain, target: self, action: #selector(handleFilter))
//        }
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "" //Removes the "Back" from navigation menu
        tableDelegate.reloadCellIfNecessary(tableView: tableView)
        view.backgroundColor    = .lightBlue
        animateResultsAreFilteredLabel()
        reloadFetchControllers()
    }
    
    func playAnimation(){
        view.addSubview(animationView)
        animationView.centerToSuperView()
        
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.3),
            animationView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.3),
            ])
        
        DispatchQueue.main.async {
            self.animationView.setAnimation(named: downloadJSON)
            self.animationView.loopAnimation = true
            self.animationView.play()
        }
    }
    
    func stopAnimation(){
        DispatchQueue.main.async {
            self.animationView.stop()
            self.animationView.removeFromSuperview()
        }
    }
}
