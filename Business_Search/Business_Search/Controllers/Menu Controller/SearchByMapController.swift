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
    var dataController: DataController!
    var searchLocationCoordinate: CLLocationCoordinate2D!
    
    var possibleInsertLocationCoordinate: CLLocation!
    
    let activityView: UIActivityIndicatorView = {
        let activityVC = UIActivityIndicatorView()
        activityVC.hidesWhenStopped = true
        activityVC.style = .gray
        activityVC.startAnimating()
        return activityVC
    }()
    
    var delegate: MenuControllerProtocol?
    
    var globalLocation = CLLocation()
    
    let pinImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "pin2"))
        imageView.isUserInteractionEnabled = false
        imageView.backgroundColor = .clear
        imageView.contentMode = .center
        imageView.isHidden = true
        // imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        //Set Center for MapView
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        mapView.delegate = self
        mapView.isHidden = true
        return mapView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    func setupUI(){
        [mapView, pinImageView, activityView].forEach{view.addSubview($0)}
        mapView.fillSafeSuperView()
        NSLayoutConstraint.activate([
            pinImageView.centerXAnchor.constraint(equalTo: mapView.centerXAnchor),
            pinImageView.centerYAnchor.constraint(equalTo: mapView.centerYAnchor),
            ])
        setupNavigationMenu()
        setupNotificationReceiver()
    }
    
    
    func setupNotificationReceiver(){
        activityView.center = view.center
        NotificationCenter.default.addObserver(self, selector: #selector(locationFound), name: Notification.Name("locationFound"), object: nil)
        print("possibleInsertLocationCoordinate ==> \(String(describing: possibleInsertLocationCoordinate))")
    }
    
    
    @objc func locationFound(){
        
        
        let temp2 = delegate?.getUserLocation()
        print("delegate --> \(String(describing: temp2))")
        
        guard let temp = delegate?.getUserLocation() else { return }
        
        activityView.stopAnimating()
        
        possibleInsertLocationCoordinate = temp
        delegate?.stopGPS()
        mapView.isHidden = false
        print("SearchByMapController --> locationFound --> possibleInsertLocationCoordinate ----> \(String(describing: possibleInsertLocationCoordinate))")
        let coordinate = possibleInsertLocationCoordinate.coordinate
        mapView.region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        pinImageView.isHidden = false
        
    }
    
    func setupNavigationMenu(){
        navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(handleNext)),
                                              UIBarButtonItem(title: "⏸", style: .done, target: self, action: #selector(handlePause))]}
    
    @objc func handlePause(){
        print(" mapView.centerCoordinate = \(mapView.centerCoordinate)")
    }
    
    @objc func handleNext(){
        let newVC = OpeningController()
        newVC.dataController = dataController
        let temp = CLLocation(latitude: globalLocation.coordinate.latitude, longitude: globalLocation.coordinate.longitude)
        newVC.possibleInsertLocationCoordinate = temp
        
        
        
        navigationController?.pushViewController(newVC, animated: true)
    }
    
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        globalLocation = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        searchLocationCoordinate = mapView.centerCoordinate
    }
    
}
