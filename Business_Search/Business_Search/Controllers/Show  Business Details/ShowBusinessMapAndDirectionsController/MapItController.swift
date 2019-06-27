//
//  GoToMap.swift
//  Business_Search
//
//  Created by admin on 5/26/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import GoogleMaps

class MapItController: UIViewController, CLLocationManagerDelegate {
    var currentBusiness: Business!              //Injected
    var _steps = [MKRoute.Step]()               //Array for Walking & Driving Routes - From Apple
    var transitSteps = [[String]]()          //2D Array for Transit Routes - From Google
    
    lazy var moveToUserLocationButton: MKUserTrackingButton = {
        let button = MKUserTrackingButton(mapView: mapView)
        button.layer.backgroundColor = UIColor.clear.cgColor
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 3
        button.layer.cornerRadius = 5
        button.isHidden = false                 //Compass is already manually added to Right Bar Button
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var scaleView: MKScaleView = {
        let scaleView = MKScaleView(mapView: mapView)
        scaleView.legendAlignment = .trailing
        scaleView.scaleVisibility = .visible
        scaleView.translatesAutoresizingMaskIntoConstraints = false
        return scaleView
    }()
    
    lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.showsCompass = false
        mapView.showsUserLocation = true
        mapView.showsPointsOfInterest = true
        mapView.delegate = self
        return mapView
    }()
    
    lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        return locationManager
    }()
    
    var currentLocation: CLLocation?
    
    lazy var compass: MKCompassButton = {
        let compass = MKCompassButton(mapView: mapView)
        compass.compassVisibility = .visible
        compass.translatesAutoresizingMaskIntoConstraints = false
        return compass
    }()
    
    lazy var directionSegmentControl: UISegmentedControl = {
        let items = ["Walking", "Driving", "Mass-Transit"]
        let segment = UISegmentedControl(items: items)
        segment.backgroundColor = .white
        segment.addTarget(self, action: #selector(handleDirectionSegmentControl(_:)), for: .valueChanged)
        segment.translatesAutoresizingMaskIntoConstraints = false
        return segment
    }()
    
    var transport = MKDirectionsTransportType.automobile    //Initializing
    let geoCoder = CLGeocoder()
    var directionsArray: [MKDirections] = []
    let regionInMeters: Double = 1000.0
    var previousLocation: CLLocation?
    
    //MARK:- Google Map
    var googleMap = GMSMapView()
    
    var showGoogleMaps = false
    
    //MARK:- Functions Below
    override func viewDidLoad() {
        super.viewDidLoad()
        print("dest -> lat = \(currentBusiness.latitude) ... lon = \(currentBusiness.longitude)")
        mapView.showsUserLocation = true
        addDestination()
        setupUI()
    }
    
    func addDestination(){
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.coordinate = CLLocationCoordinate2D(latitude: currentBusiness.latitude, longitude: currentBusiness.longitude)
        mapView.addAnnotation(destinationAnnotation)
        mapView.showAnnotations([destinationAnnotation], animated: true)
        
        //GoogleMap Stuff
        let location = locationManager.location
        guard let coord = location?.coordinate else {return}
        googleMap.camera = GMSCameraPosition(latitude: coord.latitude, longitude: coord.longitude, zoom: 17.0)
        googleMap.isMyLocationEnabled = true
        let  marker = GMSMarker(position: CLLocationCoordinate2D(latitude: currentBusiness.latitude, longitude: currentBusiness.longitude))
        marker.title = currentBusiness.name
        marker.snippet = "Info window text"
        marker.map = googleMap
    }
    
    lazy var routeTableView: UITableView = {
        let myTable = UITableView()
        myTable.delegate = self
        myTable.dataSource = self
        myTable.backgroundColor = .black
        myTable.separatorColor = UIColor.clear
        return myTable
    }()
    
    @objc func handleDirectionSegmentControl(_ sender: UISegmentedControl){
        //transport = MKDirectionsTransportType.automobile
        showGoogleMaps = false
        
        switch sender.selectedSegmentIndex {
        case 0:     showGoogleMaps = false; transport = MKDirectionsTransportType.walking; getDirections();
        case 1:     showGoogleMaps = false; transport = MKDirectionsTransportType.automobile; getDirections()
        case 2:     showGoogleMaps = true; getTransitDirections()  //MKDirectionsTransportType.transit buggy Apple Maps
        default:    print("Illegal index selected in Segment Controller")
        }
    }
    
    func setupUI(){
        if showGoogleMaps {
            mapView.isHidden = true
            googleMap.isHidden = false
        } else {
            mapView.isHidden = false
            googleMap.isHidden = true
        }
        
        let safe = view.safeAreaLayoutGuide
        [mapView, directionSegmentControl, scaleView, routeTableView, googleMap].forEach{view.addSubview($0)}
        NSLayoutConstraint.activate([
            mapView.heightAnchor.constraint(equalTo: safe.heightAnchor, multiplier: 0.5),
            googleMap.heightAnchor.constraint(equalTo: safe.heightAnchor, multiplier: 0.5),
            scaleView.topAnchor.constraint(equalTo: safe.topAnchor, constant: 5),
            scaleView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 5),
            directionSegmentControl.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            directionSegmentControl.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            directionSegmentControl.topAnchor.constraint(equalTo: mapView.bottomAnchor),
            ])
        mapView.anchor(top: safe.topAnchor, leading: safe.leadingAnchor, trailing: safe.trailingAnchor)
        googleMap.anchor(top: safe.topAnchor, leading: safe.leadingAnchor, trailing: safe.trailingAnchor)
        routeTableView.anchor(top: directionSegmentControl.bottomAnchor, leading: safe.leadingAnchor, trailing: safe.trailingAnchor, bottom: safe.bottomAnchor)
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: compass)]
    }
}


extension MapItController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 2.0
        return renderer
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        currentLocation = location
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 17.0)
        self.googleMap.animate(to: camera)
        
        /*
        //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager.stopUpdatingLocation()
        */
    }
}

extension CLLocationDistance {
    func toMiles() -> String {
        let feet = self * 3.2808
        let miles = (self) * 0.0006213712

        if feet < 125 {
            let answer = String(Int(feet)) + " feet"
            return answer
        } else {
            let answer = (miles*100).rounded()/100
            let answerString = String(answer)
            return "\(answerString) miles"
        }
    }
}