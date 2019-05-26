//
//  MapController.swift
//  Business_Search
//
//  Created by admin on 5/4/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import MapKit


class MapController: UIViewController, MKMapViewDelegate {
    
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
            compass.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            compass.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
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
            let tempAnnotation = BusinessPointAnnotation(business: business)
            tempAnnotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            tempAnnotation.title = business.name ?? ""
            
            if let price = business.price {
                tempAnnotation.subtitle = "Price: \(price)"
            }
            
            tempAnnotation.business = business
            annotations.append(tempAnnotation)
        }
    }
    
    
    //MARK:- MarkAnnotation
    //SHOWS annotation on map
    var currentBusinessAnnotation: Business?
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let selectedAnnotation = view.annotation as? BusinessPointAnnotation
        currentBusinessAnnotation = selectedAnnotation?.business
    }
    
    //TAP Accessory
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let newVC = BusinessController()
        newVC.business = currentBusinessAnnotation
        navigationController?.pushViewController(newVC, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let view = mapView.dequeueReusableAnnotationView(withIdentifier: "abc", for: annotation)    //id = mapView.register(CLUSTER_CLASS)
        if let markerAnnotationView = view as? MKMarkerAnnotationView {
            markerAnnotationView.animatesWhenAdded = true
            markerAnnotationView.canShowCallout = true

            let rightButton = UIButton(type: .detailDisclosure)
            markerAnnotationView.rightCalloutAccessoryView = rightButton
            return markerAnnotationView
        } else {
            return view
        }
    }
    
    //MARK: Test Button
    var myButtonImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "map-here2"), highlightedImage: #imageLiteral(resourceName: "map-here"))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleMyButton)))
        return imageView
    }()
    
    
    var myButton: UIButton = {
        let button = UIButton()
        button.setTitle("Click Me", for: .normal)
        button.addTarget(self, action: #selector(handleMyButton), for: .touchDown)
        return button
    }()
    
    
    @objc func handleMyButton(){
        let newVC = BusinessController()
        newVC.business = currentBusinessAnnotation
        navigationController?.pushViewController(newVC, animated: true)
    }
    
}

class BusinessPointAnnotation: MKPointAnnotation {
    var business: Business!
    init(business: Business) {
        self.business = business
    }
}


