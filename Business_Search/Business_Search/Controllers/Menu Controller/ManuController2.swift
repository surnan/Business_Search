//
//  MenuController.swift
//  Business_Search
//
//  Created by admin on 5/5/19.
//  Copyright © 2019 admin. All rights reserved.
//


/*
import UIKit
import CoreData
import CoreLocation


protocol MenuControllerProtocol {
    func getUserLocation()->CLLocation?
    func stopGPS()
}

class MenuController: UIViewController, CLLocationManagerDelegate, MenuControllerProtocol {
    func getUserLocation() -> CLLocation? {
        return userLocation
    }
    
    
    var dataController: DataController!  //MARK: Injected
    
    var locationManager: CLLocationManager!
    var userLocation: CLLocation!   //CLLocation value provided via Apple GPS
    
    var nearMeSearchButton: UIButton = {
        let button = UIButton()
        button.setTitle("Search near me", for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(handleNearMeSearchButton), for: .touchUpInside)
        return button
    }()
    
    var searchByMapButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitle("Search By Map", for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(handleSearchByMapButton), for: .touchUpInside)
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
        [nearMeSearchButton, searchByMapButton, searchByAddressButton].forEach{verticalStackView.addArrangedSubview($0)}
        [verticalStackView].forEach{view.addSubview($0)}
        NSLayoutConstraint.activate([
            verticalStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25),
            verticalStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            verticalStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            ])
    }
    
    @objc func handleSearchByAddressButton(){
        determineMyCurrentLocation()
        let newVC = SearchByAddressController()
        newVC.dataController = dataController
        newVC.delegate = self   //To center slide-Map at current location
        navigationController?.pushViewController(newVC, animated: true)
    }
    
    @objc func handleSearchByMapButton(){
        determineMyCurrentLocation()
        let newVC = SearchByMapController()
        newVC.dataController = dataController
        newVC.delegate = self   //To center slide-Map at current location
        navigationController?.pushViewController(newVC, animated: true)
    }
    
    @objc func handleNearMeSearchButton(){
        determineMyCurrentLocation()
        let newVC = OpeningController()
        newVC.dataController = dataController
        newVC.delegate = self
        navigationController?.pushViewController(newVC, animated: true)
    }
    
    
    ////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////
    //Below is to get coordinates - It's untested.  Problems working it in simulator
    
    
    
    func stopGPS() {
        locationManager.stopUpdatingLocation()
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //userLocation = locations[0] as CLLocation
        userLocation = locations.last
        
        print("(latitude, longitude) = \(userLocation.coordinate.latitude) .... \(userLocation.coordinate.longitude)")
        NotificationCenter.default.post(name: Notification.Name("locationFound"), object: nil)
    }
}
*/