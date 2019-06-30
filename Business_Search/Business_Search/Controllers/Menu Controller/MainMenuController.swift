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

protocol UnBlurDelegate{
    func undoBlur()
}


class MenuController: UIViewController, CLLocationManagerDelegate, UnBlurDelegate {
    var dataController:     DataController!     //MARK: Injected
    var locationManager:    CLLocationManager!
    var userLocation:       CLLocation!           //CLLocation value provided via Apple GPS
    var previousCoordinates: CLLocation?
    
    let activityView    = GenericActivityIndicatorView()
    var model           = MainMenuModel()
    var controllerIndex = 0
    let newVC           = SettingsController()
    
    lazy var blurredEffectView2: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = view.bounds
        return blurredEffectView
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .lightBlue
        setupNavigationMenu()
        let verticalStackView = model.getMenuButtonStack()
        view.addSubview(verticalStackView)
        NSLayoutConstraint.activate([
            verticalStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25),
            verticalStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            verticalStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            ])
    }

    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        activityView.center = view.center
//        [activityView].forEach{view.addSubview($0)}
//        previousCoordinates = nil
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addHandlers()
        activityView.center = view.center
        [activityView].forEach{view.addSubview($0)}
        previousCoordinates = nil
    }
    
    func setupNavigationMenu(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "settings"), style: .done, target: self, action: #selector(handleSettings))
        let imageView = UIImageView(image: #imageLiteral(resourceName: "BUSINESS_Finder"))
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView
    }
    
    func undoBlur() {
        blurredEffectView2.removeFromSuperview()
        navigationController?.setNavigationBarHidden(false, animated: true)
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
    
    @objc func handleSettings(){
        navigationController?.setNavigationBarHidden(true, animated: true)
        view.addSubview(blurredEffectView2)
        newVC.modalPresentationStyle = .overFullScreen
        newVC.delegate = self
        newVC.dataController = dataController
        present(newVC, animated: true, completion:nil)
    }
    
    func addHandlers(){
        [model.nearMeSearchButton, model.searchByMapButton,
         model.searchByAddressButton].forEach{$0.addTarget(self, action: #selector(handleButtons(_:)), for: .touchUpInside)}
    }
    
    
    @objc func handleButtons(_ sender: UIButton){
        determineMyCurrentLocation()
        controllerIndex = sender.tag
        activityView.startAnimating()
    }
    
    //Location Manager
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
