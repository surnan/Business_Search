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
    
    ///MARK NEW STUFF
    let geoCoder                = CLGeocoder()
    
    @objc func handleLocateAddressButton(){
        print("")
        
        geoCoder.geocodeAddressString(myTextField.text ?? "") { [weak self] (clplacement, error) in
            guard let placemarks = clplacement, let location = placemarks.first?.location else {
                self?.showAlertController(title: "Input Error", message: "Unable to find location on map")
                return
            }
            self?.locationToForward = location
            DispatchQueue.main.async {[weak self] in
                guard let self = self else {return}
//                let newAnnotation = MKPointAnnotation()
//                newAnnotation.coordinate = (self.locationToForward.coordinate)
//                let oldAnnotations = self.mapView.annotations
//                self.mapView.removeAnnotations(oldAnnotations)
//                self.mapView.addAnnotation(newAnnotation)
//                self.mapView.setCenter(newAnnotation.coordinate, animated: false)
//                let coord = self.mapView.centerCoordinate
//                self.locationToForward =  CLLocation(latitude: coord.latitude, longitude: coord.longitude)
                
                let temp2 = self.locationToForward.coordinate
                //let temp = CLLocationCoordinate2D(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)
                self.mapView.setCenter(temp2, animated: true)
            }
        }
    }
}

extension SearchByMapController {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        locationToForward = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
    }
}
