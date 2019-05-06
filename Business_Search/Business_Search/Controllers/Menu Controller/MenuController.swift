//
//  MenuController.swift
//  Business_Search
//
//  Created by admin on 5/5/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation


class MenuController: UIViewController, CLLocationManagerDelegate {
    var dataController: DataController!  //MARK: Injected
    
    var nearMeSearchButton: UIButton = {
        let button = UIButton()
        button.setTitle("Search near me", for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(handleNearMeSearchButton), for: .touchUpInside)
        return button
    }()
    
    var overThereSearchButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitle("Search By Map", for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(handleOverThereSearchButton), for: .touchUpInside)
        return button
    }()
    
    var searchByAddressButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .purple
        button.setTitle("           Search By Address           ", for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(handleSearchByAddressButton), for: .touchUpInside)
        return button
    }()
    
    var verticalStackView: UIStackView = {
       let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        [nearMeSearchButton, overThereSearchButton, searchByAddressButton].forEach{verticalStackView.addArrangedSubview($0)}
        [verticalStackView].forEach{view.addSubview($0)}
        NSLayoutConstraint.activate([
            verticalStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25),
            verticalStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            verticalStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
        ])
    }
    
    @objc func handleNearMeSearchButton(){
        determineMyCurrentLocation()
        let newVC = OpeningController()
        newVC.dataController = dataController
        // BROKEN -- newVC.searchLocationCoordinate = userLocation.coordinate
        navigationController?.pushViewController(newVC, animated: true)
    }
    
    @objc func handleSearchByAddressButton(){
        let newVC = SearchByAddressController()
        newVC.dataController = dataController
        navigationController?.pushViewController(newVC, animated: true)
    }
    
    @objc func handleOverThereSearchButton(){
        let newVC = MapOverThereController()
        newVC.dataController = dataController
        navigationController?.pushViewController(newVC, animated: true)
    }
    
    
    ////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////
    //Below is to get coordinates - It's untested.  Problems working it in simulator
    var locationManager: CLLocationManager!
    var userLocation: CLLocation!
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations[0] as CLLocation
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
    }
    
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
}

