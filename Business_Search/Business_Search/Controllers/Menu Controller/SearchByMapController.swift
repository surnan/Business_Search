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
    var dataController: DataController!                 //Injected from MenuController()
    var possibleInsertLocationCoordinate: CLLocation!   //Injected from MenuController()
    var locationToForward = CLLocation()                //Pushing into newController()
    
    let pinImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "pin2"))
        imageView.isUserInteractionEnabled = false
        imageView.backgroundColor = .clear
        imageView.contentMode = .center
        // imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        if let _ = possibleInsertLocationCoordinate {
            mapView.region = MKCoordinateRegion(center: possibleInsertLocationCoordinate.coordinate,
                                                latitudinalMeters: 500,
                                                longitudinalMeters: 500)
        }
        
        mapView.delegate = self
        return mapView
    }()
    
    //MARK:- UI
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    @objc func handlePause() {print(" mapView.centerCoordinate = \(mapView.centerCoordinate)")}
    
    @objc func handleNext(){
        let newVC = OpeningController()
        newVC.dataController = dataController
        newVC.latitude = locationToForward.coordinate.latitude
        newVC.longitude = locationToForward.coordinate.longitude
        navigationController?.pushViewController(newVC, animated: true)
    }

    func setupUI(){
        [mapView, pinImageView].forEach{view.addSubview($0)}
        mapView.fillSafeSuperView()
        NSLayoutConstraint.activate([
            pinImageView.centerXAnchor.constraint(equalTo: mapView.centerXAnchor),
            pinImageView.centerYAnchor.constraint(equalTo: mapView.centerYAnchor),
            ])
        navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(handleNext)),
                                              UIBarButtonItem(title: "⏸", style: .done, target: self, action: #selector(handlePause))]
    }
    
    //MARK:- Map Delegate Function
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        locationToForward = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
    }
}
