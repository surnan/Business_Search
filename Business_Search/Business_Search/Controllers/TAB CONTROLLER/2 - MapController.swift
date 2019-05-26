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
            annotations.append(tempAnnotation)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        return BusinessAnnotation(annotation: annotation, reuseIdentifier: "abc")
    }
}

class BusinessAnnotation: MKMarkerAnnotationView {
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = "BusinessClusterID"
        collisionMode = .circle
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        displayPriority = .defaultLow
        markerTintColor = UIColor.blue
        if let cluster = annotation as? MKClusterAnnotation {
            let total = cluster.memberAnnotations.count
            image = drawCustomBusinessAnnotationCircle(count: total)
        }
    }
    
    private func drawCustomBusinessAnnotationCircle(count: Int) -> UIImage {
        return drawCircle(color: UIColor.orange)
    }
    
    private func drawCircle(color: UIColor?) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 40, height: 40))
        return renderer.image { _ in
            color?.setFill()
            UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 40, height: 40)).fill()
        }
    }
}
