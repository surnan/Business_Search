//
//  BusinessController.swift
//  Business_Search
//
//  Created by admin on 5/10/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData
import MapKit
import CoreLocation

class BusinessDetailsController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    let regionMetersForMap      = 400.0
    var currentLocation         : CLLocation?
    var locationManager         = GenericCLLocationManager(desiredAccuracy: kCLLocationAccuracyBest)
    var model                   = BusinessDetailsModel()
    var business                : Business! {didSet { model.business = business }}
    var coordinator             : (OpenInSafariType & OpenAppleMapType)?
    
    //MARK:- Functions START
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = UIColor.white
        setupUI()
        setupMapView()
    }
    
    override func viewDidLoad() {
        addHandlers()
        setupLocationManager()
    }
    
    func setupMapView(){
        let viewRegion = MKCoordinateRegion(center: model.firstAnnotation.coordinate,
                                            latitudinalMeters: regionMetersForMap,
                                            longitudinalMeters: regionMetersForMap)
        model.mapView.setRegion(viewRegion, animated: false)
        model.mapView.addAnnotation(model.firstAnnotation)
        model.mapView.delegate = self
    }
    
    func setupLocationManager(){
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    //MARK:- Handlers
    func addHandlers(){
        model.phoneNumberButton.addTarget(self, action: #selector(handlePhoneNumberButton(sender:)), for: .touchUpInside)
        model.visitYelpPageButton.addTarget(self, action: #selector(handleVisitYelpPageButton(_:)), for: .touchUpInside)
        model.mapItButton.addTarget(self, action: #selector(handleMapItButton(_:)), for: .touchUpInside)
    }
    
    @objc func handlePhoneNumberButton(sender: UIButton){
        guard let numberString = sender.titleLabel?.text else {return}
        let number = numberString.filter("0123456789".contains)
        if let url = URL(string: "tel://\(number)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    @objc func handleVisitYelpPageButton(_ sender: UIButton){
        if let urlStringExists = business.url, urlStringExists._isValidURL {
            coordinator?.handleOpenBrowser(urlString: urlStringExists)
        } else {
            coordinator?.handleOpenBrowser(urlString: "https://www.yelp.com")
        }
    }
    
    @objc func handleMapItButton(_ sender: UIButton){
        guard let currentLocation = locationManager.location?.coordinate else {print("Unable to get current Location"); return}
        coordinator?.handleMapItButton(currentLocation: currentLocation)
    }
}

