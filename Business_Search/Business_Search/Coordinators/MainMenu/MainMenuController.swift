//
//  MenuController.swift
//  Business_Search
//
//  Created by admin on 5/5/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreLocation

class MainMenuController: UIViewController, UnBlurViewType{
    var locationManager         : CLLocationManager!
    var userLocation            : CLLocation!       //Provided via Apple GPS
    var previousCoordinate      : CLLocation?       /* Still Necessary */
    var coordinateFound         : Bool!             //Prevent locationManger multi-fire 'func pushNextController'
    var coordinator             : (SearchTableType & SearchByMapType & SearchByAddressType & SettingsType)?
    var controllerIndex         = 0
    let mainView                = MainMenuView()
    lazy var stack              = mainView.getButtonStack()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent                        //Status bar sometimes black
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

    func undoBlur() {
        removeDarkScreenBlur()
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

