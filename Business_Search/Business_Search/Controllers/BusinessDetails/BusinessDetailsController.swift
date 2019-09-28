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
    let regionMeters    = 400.0
    var model           = BusinessDetailsModel()
    var locationManager = GenericCLLocationManager(desiredAccuracy: kCLLocationAccuracyBest)
    
    var business        : Business! {didSet { model.business = business }}
    var currentLocation : CLLocation?
    
    //MARK:- Functions START
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = UIColor.white
        setupUI()
    }
    
    override func viewDidLoad() {
        addHandlers()
        setupMapView()
        setupLocationManager()
    }
    
    func setupMapView(){
        let viewRegion = MKCoordinateRegion(center: model.firstAnnotation.coordinate, latitudinalMeters: regionMeters, longitudinalMeters: regionMeters)
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
            let verifiedURLStringFormatted = urlStringExists._prependHTTPifNeeded()
            if let url = URL(string: verifiedURLStringFormatted) {
                UIApplication.shared.open(url)
                return
            }
        }
        UIApplication.shared.open(URL(string: "https://www.yelp.com")!)
    }
    
    @objc func handleMapItButton(_ sender: UIButton){
        guard let currentLocation = locationManager.location?.coordinate else {print("Unable to get current Location"); return}
        let source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: currentLocation.latitude, longitude: currentLocation.longitude)))
        let destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: business.latitude, longitude: business.longitude)))
        source.name = "Your Location"; destination.name = "Destination"
        MKMapItem.openMaps(with: [source, destination], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
}

