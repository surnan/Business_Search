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
    var locationManager         : CLLocationManager!
    var userLocation            : CLLocation!       //Provided via Apple GPS
    var previousCoordinate      : CLLocation?
    var coordinateFound         : Bool!             //Prevent 'func pushNextController' trigger twice
                                                    //multiple hits serially from locationManager
    
    let activityView            = GenericActivityIndicatorView()
    var controllerIndex         = 0
    var coordinator             : (SearchTableType & SearchByMapType & SearchByAddressType & SettingsType)?
    var nearMeSearchButton      = MainMenuControllerButton(title: "Search Near Me", background: .blue, tag: 0)
    var searchByMapButton       = MainMenuControllerButton(title: "Search By Map", background: .red, tag: 1)
    var searchByAddressButton   = MainMenuControllerButton(title: "     Search By Address     ", background: .green, tag: 2)

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor    = .lightBlue
        previousCoordinate      = nil
        coordinateFound         = false
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
        case 0: coordinator.loadSearchTable(location: userLocation)
        case 1: coordinator.loadSearchByMap(location: userLocation)
        case 2: coordinator.loadSearchByAddress(location: userLocation)
        default:    break
        }
    }
    
    func addHandlers(){
        [nearMeSearchButton, searchByMapButton, searchByAddressButton]
            .forEach{$0.addTarget(self, action: #selector(handleButtons(_:)), for: .touchUpInside)}
    }
    
    @objc func handleButtons(_ sender: UIButton){
        determineMyCurrentLocation()
        controllerIndex = sender.tag
        activityView.startAnimating()
    }
    
    @objc func handleSettings(){
        addDarkScreenBlur()
        coordinator?.loadSettings(delegate: self, max: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent       //Status bar sometimes black on searchbar editing or presenting clear VC fullscreen
    }
}
