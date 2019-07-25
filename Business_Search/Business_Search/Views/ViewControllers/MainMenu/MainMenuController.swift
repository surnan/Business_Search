//
//  MenuController.swift
//  Business_Search
//
//  Created by admin on 5/5/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreLocation

class MainMenuController: UIViewController, UnBlurViewProtocol{
    var dataController      : DataController!       //MARK: Injected
    var locationManager     : CLLocationManager!
    var userLocation        : CLLocation!           //Provided via Apple GPS
    var previousCoordinate  : CLLocation?
    var coordinateFound     : Bool!                 //Prevent 'func pushNextController' trigger twice
                                                    //multiple hits serially from locationManager
    let activityView        = GenericActivityIndicatorView()
    var viewModel           = MainMenuViewModel()
    var controllerIndex     = 0
    var coordinator         : (OpeningType & SearchByMapType & SearchByAddressType & SettingsType)?


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor    = .lightBlue
        previousCoordinate      = nil
        coordinateFound         = false //tested in 'ViewDidAppear'
        setupUI()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addHandlers()
        activityView.center = view.center
        view.addSubview(activityView)
    }
    

    func pushNextController(){
        guard let coordinator = coordinator else {print("coordinator is NIL");return}
        activityView.stopAnimating()
        if coordinateFound {return}
        coordinateFound = true
        switch controllerIndex {
        case 0: coordinator.pushOpenController(dataController: dataController, location: userLocation)
        case 1: coordinator.pushSearchByMap(dataController: dataController, location: userLocation)
        case 2: coordinator.pushSearchByAddress(dataController: dataController, location: userLocation)
        default:    break
        }
    }
    
    func addHandlers(){
        [viewModel.nearMeSearchButton, viewModel.searchByMapButton, viewModel.searchByAddressButton]
            .forEach{$0.addTarget(self, action: #selector(handleButtons(_:)), for: .touchUpInside)}
    }
    
    @objc func handleButtons(_ sender: UIButton){
        determineMyCurrentLocation()
        controllerIndex = sender.tag
        activityView.startAnimating()
    }
    
    @objc func handleSettings(){
        addDarkScreenBlur()
        coordinator?.handleSettings(dataController: dataController, delegate: self, max: nil)
    }
}
