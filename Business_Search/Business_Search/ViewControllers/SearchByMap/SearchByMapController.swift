//
//  OverThereLocation.swift
//  Business_Search
//
//  Created by admin on 5/5/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class SearchByMapController: UIViewController, MKMapViewDelegate{
    var coordinator             : SearchTableType?          //injected
    
    //MARK:- ViewObject + ViewModel Var
    var viewObject              : SearchByMapView!
    var viewModel               : SearchByMapViewModel! {
        didSet{
            showHideButton      = viewObject.showHideAddressBarButton
            locateAddressButton = viewObject.locateAddressButton
            myTextField         = viewObject.myTextField
            pinImageView        = viewObject.pinImageView
            mapView             = viewObject.mapView
            belowSafeView       = viewObject.redView
        }
    }
    
    var pinImageView            : UIImageView!
    var mapView                 : MKMapView!
    var showHideButton          : UIButton!
    var locateAddressButton     : UIButton!
    var myTextField             : UITextField!
    var anchorMap_SafeAreaTop   : NSLayoutConstraint?
    var anchorMap_ShowHideButton: NSLayoutConstraint?
    var belowSafeView           : UIView!

    //MARK:- Local Var
    var locationToForward       = CLLocation()                //Pushed to newController()
    var hideAddressBar          = false {
        didSet {
            addressBarStack.isHidden = hideAddressBar
        }
    }
    
    var addressBarStack: UIStackView = {
        var stack = UIStackView()
        stack.spacing = 10
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        mapView.delegate = self
        addHandlers()
        setupUI()
    }
}

extension SearchByMapController {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        locationToForward = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
    }
}
