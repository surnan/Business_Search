//
//  MenuController.swift
//  Business_Search
//
//  Created by admin on 5/5/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreLocation

class MenuController: UIViewController, UnBlurViewProtocol{
    var dataController      : DataController!         //MARK: Injected
    var locationManager     : CLLocationManager!
    var userLocation        : CLLocation!             //Provided via Apple GPS
    var previousCoordinate  : CLLocation?
    let activityView        = GenericActivityIndicatorView()
    var model               = MainMenuModel()
    var controllerIndex     = 0
    var coordinator         : (SettingsType & OpeningType & SearchByMapType & SearchByAddressType)?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor    = .lightBlue
        previousCoordinate      = nil
        setupUI()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addHandlers()
        activityView.center = view.center
        view.addSubview(activityView)
    }
    
    func setupNavigationMenu(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "settings"), style: .done, target: self, action: #selector(handleSettings))
        let imageView = UIImageView(image: #imageLiteral(resourceName: "BUSINESS_Finder"))
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        coordinateFound = false
    }
    
    
    var coordinateFound = false
    
    func pushNextController(){
        guard let coordinator = coordinator else {print("coordinator is NIL");return}
        activityView.stopAnimating()
        print("coordinateFound == \(coordinateFound)")
        if coordinateFound {return} //Navigation Delegate will sometimes send multiple locations and rapid fire this function
        coordinateFound = true
        switch controllerIndex {
        case 0: coordinator.handleOpenController(dataController: dataController, location: userLocation)
        case 1: coordinator.handleSearchByMap(dataController: dataController, location: userLocation)
        case 2: coordinator.handleSearchByAddress(dataController: dataController, location: userLocation)
        default:    break
        }
    }
    
    func setupUI(){
        setupNavigationMenu()
        let verticalStackView = model.getMenuButtonStack()
        view.addSubview(verticalStackView)
        NSLayoutConstraint.activate([
            verticalStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25),
            verticalStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            verticalStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            ])
    }
    
    func undoBlur() {
        removeDarkScreenBlur()
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @objc func handleButtons(_ sender: UIButton){
        determineMyCurrentLocation()
        controllerIndex = sender.tag
        activityView.startAnimating()
    }
    
    func _handlSettings(self viewController: UnBlurViewProtocol, dataController: DataController){
        let newVC = SettingsController()
        newVC.delegate = viewController
        newVC.dataController = dataController
        newVC.modalPresentationStyle = .overFullScreen
        present(newVC, animated: true, completion: nil)
    }
    
    @objc func handleSettings(){
        navigationController?.setNavigationBarHidden(true, animated: true)
        view.addSubview(blurringScreenDark)
        addDarkScreenBlur()
        let newVC               = SettingsController()
        newVC.delegate          = self
        newVC.dataController    = dataController
        newVC.modalPresentationStyle = .overFullScreen
        present(newVC, animated: true, completion: nil)
    }
    
    func addHandlers(){
        [model.nearMeSearchButton, model.searchByMapButton, model.searchByAddressButton]
            .forEach{$0.addTarget(self, action: #selector(handleButtons(_:)), for: .touchUpInside)}
    }
}



