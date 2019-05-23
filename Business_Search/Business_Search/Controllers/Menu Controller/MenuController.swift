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
        button.tag = 0
        //button.addTarget(self, action: #selector(handleNearMeSearchButton(_:)), for: .touchUpInside)
        button.addTarget(self, action: #selector(handleButtons(_:)), for: .touchUpInside)
        return button
    }()
    
    var searchByMapButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitle("Search By Map", for: .normal)
        button.layer.cornerRadius = 10
        button.tag = 1
        //button.addTarget(self, action: #selector(handleSearchByMapButton(_:)), for: .touchUpInside)
        button.addTarget(self, action: #selector(handleButtons(_:)), for: .touchUpInside)
        return button
    }()
    
    var searchByAddressButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .purple
        button.setTitle("           Search By Address           ", for: .normal)
        button.layer.cornerRadius = 10
        button.tag = 2
        //button.addTarget(self, action: #selector(handleSearchByAddressButton(_:)), for: .touchUpInside)
        button.addTarget(self, action: #selector(handleButtons(_:)), for: .touchUpInside)
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

    var controllerIndex = 0
    var previousCoordinates: CLLocation?
    
    @objc func handleButtons(_ sender: UIButton){
        determineMyCurrentLocation()
        controllerIndex = sender.tag
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations.last
        locationManager.stopUpdatingLocation()
        
        if previousCoordinates == nil {
            previousCoordinates = userLocation
            //TODO: Push VC
            pushNextController()
        } else if let previous = previousCoordinates, userLocation.distance(from: previous) > 10 {
            userLocation = previous
            //TODO: Push VC
            pushNextController()
        }
    }
    
    
    func pushNextController(){
        switch controllerIndex {
        case 0:
            let newVC = OpeningController()
            newVC.dataController = dataController
            newVC.possibleInsertLocationCoordinate = userLocation
            navigationController?.pushViewController(newVC, animated: true)
        case 1:
            let newVC = SearchByMapController()
            newVC.dataController = dataController
            newVC.possibleInsertLocationCoordinate = userLocation
            navigationController?.pushViewController(newVC, animated: true)
        case 2:
            let newVC = SearchByAddressController()
            newVC.dataController = dataController
            newVC.possibleInsertLocationCoordinate = userLocation
            navigationController?.pushViewController(newVC, animated: true)
        default:
            break
        }
    }
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        previousCoordinates = nil
    }
    
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
    
    /*
    @objc func handleSearchByAddressButton(_ sender: UIButton){
        determineMyCurrentLocation()
        let newVC = SearchByAddressController()
        newVC.dataController = dataController
        newVC.delegate = self   //To center slide-Map at current location
        navigationController?.pushViewController(newVC, animated: true)
    }
    
    @objc func handleSearchByMapButton(_ sender: UIButton){
        determineMyCurrentLocation()
        let newVC = SearchByMapController()
        newVC.dataController = dataController
        newVC.delegate = self   //To center slide-Map at current location
        navigationController?.pushViewController(newVC, animated: true)
    }
    
    @objc func handleNearMeSearchButton(_ sender: UIButton){
        determineMyCurrentLocation()
        let newVC = OpeningController()
        newVC.dataController = dataController
        newVC.delegate = self
        navigationController?.pushViewController(newVC, animated: true)
    }
    */
    
    
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
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        //userLocation = locations[0] as CLLocation
//        userLocation = locations.last
//        print("(latitude, longitude) = \(userLocation.coordinate.latitude) .... \(userLocation.coordinate.longitude)")
//        NotificationCenter.default.post(name: Notification.Name("locationFound"), object: nil)
//    }
}

