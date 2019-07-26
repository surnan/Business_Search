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
    var previousCoordinate      : CLLocation?       /* Still Necessary */
    var coordinateFound         : Bool!             //Prevent locationManger multi-fire 'func pushNextController'
    var coordinator             : (SearchTableType & SearchByMapType & SearchByAddressType & SettingsType)?
    var controllerIndex         = 0
    let mainView                = MainMenuView()
    lazy var stack              = mainView.getButtonStack()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent       //Status bar sometimes black
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor    = .lightBlue
        coordinateFound         = false
        previousCoordinate      = nil
        setupUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addHandlers()
        [mainView.activityView, stack].forEach{view.addSubview($0)}
    }
    
    func setupUI(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "settings"), style: .done, target: self, action: #selector(handleSettings))
        self.navigationItem.titleView = mainView.titleImage
        mainView.activityView.center = view.center
        NSLayoutConstraint.activate([
            stack.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25),
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            ])
    }

    func addHandlers(){
        [mainView.nearMeSearchButton, mainView.searchByMapButton, mainView.searchByAddressButton].forEach{
                $0.addTarget(self, action: #selector(handleButtons(_:)), for: .touchUpInside)
        }
    }
    
    func undoBlur() {
        removeDarkScreenBlur()
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

