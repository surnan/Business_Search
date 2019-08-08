//
//  SearchByAddressController.swift
//  Business_Search
//
//  Created by admin on 5/5/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit


class SearchByAddressController: UIViewController, UITextFieldDelegate, MKMapViewDelegate, UIGestureRecognizerDelegate {
    var coordinator             : SearchTableType?
    var viewObject              : SearchByAddressView!
    var viewModel               : SearchByAddressViewModel!
    
    let geoCoder                = CLGeocoder()
    var locationToForward       = CLLocation()                //Pushing into newController()
    lazy var mapView            = viewObject.mapView
    lazy var locationImageView  = viewObject.locationImageView
    lazy var locationTextField  = viewObject.locationTextField
    lazy var findLocationButton = viewObject.findLocationButton
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        locationTextField.delegate = self
        setupUI()
        addHandlers()
    }
    
    //MARK:- TextField Delegate
    func textFieldDidEndEditing(_ textField: UITextField) {view.endEditing(true)}
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {view.endEditing(true); return true}
}
