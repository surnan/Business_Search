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

class ShowMultipleBusinessMapController: UIViewController, CLLocationManagerDelegate {
    
    var business: Business!     //Injected
    var _steps = [MKRoute.Step]()
    
    var tableViewArrays = [[String]]()  //Forwarding 2D Array for Transit Routes
    
    lazy var moveToUserLocationButton: MKUserTrackingButton = {
        let button = MKUserTrackingButton(mapView: mapView)
        button.layer.backgroundColor = UIColor.clear.cgColor
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 3
        button.layer.cornerRadius = 5
        button.isHidden = false      //Compass is already manually added to Right Bar Button
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
        mapView.delegate = self  //--> rename 'GoToMapController2' to 'GoToMapController'
        return mapView
    }()
    
    lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        return locationManager
    }()
    
    lazy var compass: MKCompassButton = {
        let compass = MKCompassButton(mapView: mapView)
        compass.compassVisibility = .visible
        compass.translatesAutoresizingMaskIntoConstraints = false
        return compass
    }()
    
    let geoCoder = CLGeocoder()
    var directionsArray: [MKDirections] = []
    let regionInMeters: Double = 1000.0
    var previousLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("dest -> lat = \(business.latitude) ... lon = \(business.longitude)")
        
        mapView.showsUserLocation = true
        addDestination()
        [mapView, directionSegmentControl, scaleView].forEach{view.addSubview($0)}
        
        
        
        
        NSLayoutConstraint.activate([
            directionSegmentControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            directionSegmentControl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            directionSegmentControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scaleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            scaleView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            ])
        
        let safe = view.safeAreaLayoutGuide
        mapView.anchor(top: safe.topAnchor, leading: safe.leadingAnchor, trailing: safe.trailingAnchor, bottom: directionSegmentControl.topAnchor)
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: moveToUserLocationButton),
                                              UIBarButtonItem(customView: compass),
                                              UIBarButtonItem(title: "Table", style: .done, target: self, action: #selector(hendleNextTable))]
    }
    
    @objc func hendleNextTable(){
        let newVC = ShowBusinessRouteTableViewController()
        newVC.steps = _steps
        navigationController?.pushViewController(newVC, animated: true)
    }
    
    func addDestination(){
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.coordinate = CLLocationCoordinate2D(latitude: business.latitude, longitude: business.longitude)
        mapView.addAnnotation(destinationAnnotation)
        mapView.showAnnotations([destinationAnnotation], animated: true)
    }
    
    
    //Move map center to current GPS coordinate
    func centerViewOnUserLocation(){
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: location,
                                            latitudinalMeters: regionInMeters,
                                            longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    lazy var directionSegmentControl: UISegmentedControl = {
        let items = ["Walking", "Driving", "Mass-Transit"]
        let segment = UISegmentedControl(items: items)
        //segment.selectedSegmentIndex = 0
        segment.backgroundColor = .white
        segment.addTarget(self, action: #selector(handleDirectionSegmentControl(_:)), for: .valueChanged)
        segment.translatesAutoresizingMaskIntoConstraints = false
        return segment
    }()
    
    @objc func handleDirectionSegmentControl(_ sender: UISegmentedControl){
        //transport = MKDirectionsTransportType.automobile
        switch sender.selectedSegmentIndex {
        case 0:
            transport = MKDirectionsTransportType.walking
        case 1:
            transport = MKDirectionsTransportType.automobile
        case 2:
            //transport = MKDirectionsTransportType.transit
            getTransitDirections()
        default:
            print("Illegal index selected in Segment Controller")
        }
        getDirections()
    }
    
    //MARK:- connecting destination & source
    
    

    
    
    
    func getDirections(){
        guard let location = locationManager.location?.coordinate else {
            //TODO: Inform user we don't have their current location
            return
        }
        let request = createDirectionsRequest(from: location)
        let directions = MKDirections(request: request)
        resetMapView(withNew: directions)
        directions.calculate { [unowned self](response, error) in
            guard let response = response else { return }   //TODO: Show response not availabe in an alert
            for route in response.routes {  //an array of routes (below 'AlternateRoutes = true').
                let steps = route.steps //Direction each phase (turn right, go straight 5 miles, etc)
                self._steps = steps     //Pushing to New View Controller
                self.mapView.addOverlay(route.polyline)
                //Fit whole map-route onto screen
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    var transport = MKDirectionsTransportType.automobile
    
    func createDirectionsRequest(from coordinate: CLLocationCoordinate2D)-> MKDirections.Request {
        let destinationCoordinate       = getCenterLocation(for: mapView).coordinate
        let startingLocation            = MKPlacemark(coordinate: coordinate)
        let destination                 = MKPlacemark(coordinate: destinationCoordinate)
        let request                     = MKDirections.Request()
        request.source                  = MKMapItem(placemark: startingLocation)
        request.destination             = MKMapItem(placemark: destination)
        request.transportType           = transport                         //From Segment Controller
        request.requestsAlternateRoutes = true
        return request
    }
    
    
    func resetMapView(withNew directions: MKDirections){
        mapView.removeOverlays(mapView.overlays)
        directionsArray.append(directions)
        let _ = directionsArray.map {$0.cancel()}
        directionsArray.removeAll()
    }
    
    func getCenterLocation(for mapView: MKMapView)-> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        return CLLocation(latitude: latitude, longitude: longitude)
    }
}


extension ShowMultipleBusinessMapController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 2.0
        return renderer
    }
}



