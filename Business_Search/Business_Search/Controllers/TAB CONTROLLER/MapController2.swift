//
//  MapController.swift
//  Business_Search
//
//  Created by admin on 5/4/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import MapKit


class MapController2: UIViewController, MKMapViewDelegate {
    
    var businesses = [Business]()   //injected
    var annotations = [MKPointAnnotation]()
    var mapView = MKMapView()
    
    lazy var moveToUserLocationButton: MKUserTrackingButton = {
        let button = MKUserTrackingButton(mapView: mapView)
        button.layer.backgroundColor = UIColor.clear.cgColor
        button.layer.borderColor = UIColor.clear.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.isHidden = false
        return button
    }()
    
    lazy var scaleView: MKScaleView = {
        let view = MKScaleView(mapView: mapView)
        view.legendAlignment = .trailing
        view.scaleVisibility = .visible  // By default, `MKScaleView` uses adaptive visibility
        return view
    }()
    
    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [scaleView, moveToUserLocationButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 10
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)])
    }
    
    lazy var compass: MKCompassButton = {
        let compass = MKCompassButton(mapView: mapView)
        compass.compassVisibility = .visible
        compass.translatesAutoresizingMaskIntoConstraints = false
        return compass
    }()
    
    
    func setupCompass() {
        view.addSubview(compass)
        NSLayoutConstraint.activate([
            compass.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            compass.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15)
            ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
        setupStackView()
        setupCompass()
    }
    
    func setupMap(){
        mapView.delegate = self
        mapView.register(BusinessAnnotation.self, forAnnotationViewWithReuseIdentifier: "abc")
        convertLocationsToAnnotations()
        mapView.addAnnotations(annotations)  //There's a singular & plural for 'addAnnotation'.  OMG
        mapView.showAnnotations(annotations, animated: true)
        [mapView].forEach{view.addSubview($0)}
        mapView.fillSafeSuperView()
    }
    
    private func convertLocationsToAnnotations(){
        for business in businesses {
            let latitude = CLLocationDegrees(business.latitude)
            let longitude = CLLocationDegrees(business.longitude)
            let tempAnnotation = MKPointAnnotation()
            tempAnnotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            tempAnnotation.title = business.name ?? ""
            tempAnnotation.subtitle = business.price == nil ? "Rating: \(business.rating)" : "Rating: \(business.rating)     Price: \(business.price!)"
            annotations.append(tempAnnotation)
        }
    }
    
    
    //MARK:- MarkAnnotation
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        //reuse Identifier sets it to BusinessAnnotation through registration
        let view = mapView.dequeueReusableAnnotationView(withIdentifier: "abc", for: annotation)
        if let markerAnnotationView = view as? MKMarkerAnnotationView {
            markerAnnotationView.animatesWhenAdded = true
            markerAnnotationView.canShowCallout = true
            let rightButton = UIButton(type: .detailDisclosure)
            //rightButton.addTarget(self, action: #selector(printHello(business:)), for: .touchUpInside)
            markerAnnotationView.rightCalloutAccessoryView = rightButton
        }
        return view
    }
    
    @objc func printHello(business: Business){
        print("HELLO WORLD")
        let newVC = BusinessController()
        newVC.business = business
        present(newVC, animated: true, completion: nil)
    }
}


