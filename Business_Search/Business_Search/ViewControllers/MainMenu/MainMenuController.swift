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
    lazy var nearMeButton       = mainView.getNearMeButton()
    lazy var byMapButton        = mainView.getByMapButton()
    lazy var byAddressButton    = mainView.getByAddressButton()
    var locationViewModel       : LocationViewModel!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent                        //Status bar sometimes black
    }
}

