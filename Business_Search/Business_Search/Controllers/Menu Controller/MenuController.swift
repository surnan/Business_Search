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

    var dataController: DataController!     //MARK: Injected
    var locationManager: CLLocationManager!
    var userLocation: CLLocation!           //CLLocation value provided via Apple GPS

    let activityView: UIActivityIndicatorView = {
        let activityVC = UIActivityIndicatorView()
        activityVC.hidesWhenStopped = true
        activityVC.style = .gray
        return activityVC
    }()
    
    var nearMeSearchButton: UIButton = {
        let button = UIButton()
        button.setTitle("Search near me", for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 10
        button.tag = 0
        button.addTarget(self, action: #selector(handleButtons(_:)), for: .touchUpInside)
        return button
    }()
    
    var searchByMapButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitle("Search By Map", for: .normal)
        button.layer.cornerRadius = 10
        button.tag = 1
        button.addTarget(self, action: #selector(handleButtons(_:)), for: .touchUpInside)
        return button
    }()
    
    var searchByAddressButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .purple
        button.setTitle("           Search By Address           ", for: .normal)
        button.layer.cornerRadius = 10
        button.tag = 2
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
        activityView.startAnimating()
//        handleButtons2(sender)
    }
    
    
    func handleButtons2(_ sender: UIButton){
        let newVC = SearchByAddressController()
        newVC.dataController = dataController
        newVC.possibleInsertLocationCoordinate = userLocation
        navigationController?.pushViewController(newVC, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations.last
        locationManager.stopUpdatingLocation()
        
        if previousCoordinates == nil {
            previousCoordinates = userLocation
            pushNextController()
        } else if let previous = previousCoordinates, userLocation.distance(from: previous) > 10 {
            userLocation = previous
            pushNextController()
        }
    }
    
    func pushNextController(){
        activityView.stopAnimating()
        switch controllerIndex {
        case 0:
            let newVC = OpeningController()
            newVC.dataController = dataController
            newVC.latitude = userLocation.coordinate.latitude
            newVC.longitude = userLocation.coordinate.longitude
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
        activityView.center = view.center
        [activityView].forEach{view.addSubview($0)}
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
        setupNavigationMenu()
    }
    
    func setupNavigationMenu(){
        navigationItem.leftBarButtonItems = [UIBarButtonItem(title: "❁", style: .done, target: self, action: #selector(handleBack))]
    }
    
    @objc func handleBack(){
        present(SettingsController(), animated: true, completion: nil)
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
