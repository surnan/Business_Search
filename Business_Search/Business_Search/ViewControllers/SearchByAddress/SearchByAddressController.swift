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


class SearchByAddressController: UIViewController, UITextViewDelegate, UITextFieldDelegate, MKMapViewDelegate, UIGestureRecognizerDelegate {
    var coordinator             : SearchTableType?
    var viewObject              : SearchByAddressView!
    var viewModel               : SearchByAddressViewModel!
    
    let geoCoder                = CLGeocoder()
    var locationToForward       = CLLocation()                //Pushing into newController()
    var barButtonState          = ButtonState.disabled
    var found                   = false
    
    lazy var mapView            = viewObject.mapView
    lazy var locationImageView  = viewObject.locationImageView
    lazy var locationTextField  = viewObject.locationTextField
    lazy var myTextField        = viewObject.myTextField
    lazy var myButton           = viewObject.myButton
    
    
    let textViewMaxHeight: CGFloat = 50
    
    enum ButtonState {
        case disabled, find, next
    }
}





