//
//  MenuController.swift
//  Business_Search
//
//  Created by admin on 5/5/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreLocation

class MenuController: UIViewController, UnBlurViewProtocol {
    var coordinator: (PushOpen & PushSearchByMap & PushSearchByAddress & PresentSettings)?
    var dataController      : DataController!            //MARK: Injected
    var locationManager     : CLLocationManager!
    var userLocation        : CLLocation!             //Provided via Apple GPS
    var previousCoordinate  : CLLocation?
    let activityView        = GenericActivityIndicatorView()
    var model               = MainMenuModel()
    var controllerIndex     = 0

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
    
    func pushNextController(){
        activityView.stopAnimating()
        switch controllerIndex {
        case 0: coordinator?.pushOpenCoordinator(userLocation: userLocation)
        case 1: coordinator?.pushSearchByMapCoordinator(location: userLocation)
        case 2: coordinator?.pushSearchByAddressCoordinator(location: userLocation)
        default:break
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
    
    func addHandlers(){
        [model.nearMeSearchButton, model.searchByMapButton, model.searchByAddressButton]
            .forEach{$0.addTarget(self, action: #selector(handleButtons(_:)), for: .touchUpInside)}
    }
    
    @objc func handleButtons(_ sender: UIButton){
        determineMyCurrentLocation()
        controllerIndex = sender.tag
        activityView.startAnimating()
    }
    
    @objc func handleSettings(){
        navigationController?.setNavigationBarHidden(true, animated: true)
        view.addSubview(blurringScreenDark)
        blurringScreenDark.fillSuperview()
        
//        let newVC               = SettingsController()
//        newVC.delegate          = self
//        newVC.dataController    = dataController
//        newVC.modalPresentationStyle = .overFullScreen
//        present(newVC, animated: true, completion:nil)
        
        
        coordinator?.presentSettingsCoordinator(destination: self)
        
        
        
    }
}


