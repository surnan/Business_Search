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


class OverThereController: UIViewController, MKMapViewDelegate{
    var dataController: DataController!
    var searchLocationCoordinate: CLLocationCoordinate2D!
    
    let pinImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "pin2"))
        imageView.isUserInteractionEnabled = false
        imageView.backgroundColor = .clear
         imageView.contentMode = .center
//        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    

    lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        mapView.region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.delegate = self
        return mapView
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    func setupUI(){
        [mapView, pinImageView].forEach{view.addSubview($0)}
        mapView.fillSafeSuperView()
        
        NSLayoutConstraint.activate([
            pinImageView.centerXAnchor.constraint(equalTo: mapView.centerXAnchor),
            pinImageView.centerYAnchor.constraint(equalTo: mapView.centerYAnchor),
            ])
        setupNavigationMenu()
    }
    
    func setupNavigationMenu(){
        navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(handleNext)), UIBarButtonItem(title: "⏸", style: .done, target: self, action: #selector(handlePause))]
    }
    
    @objc func handlePause(){
        print(" mapView.centerCoordinate = \(mapView.centerCoordinate)")
    }
    
    @objc func handleNext(){
        let newVC = OpeningController()
        newVC.dataController = dataController
        newVC.searchLocationCoordinate = searchLocationCoordinate
        navigationController?.pushViewController(newVC, animated: true)
    }
    
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        searchLocationCoordinate = mapView.centerCoordinate
    }
    
}
