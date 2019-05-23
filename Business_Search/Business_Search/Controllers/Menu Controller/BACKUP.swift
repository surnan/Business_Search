//
//  SearchByAddressController.swift
//  Business_Search
//
//  Created by admin on 5/5/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit


class SearchByAddressController2: UIViewController, UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    var dataController: DataController!
    var delegate: MenuControllerProtocol?
    
    var globalLocation = CLLocation()
    let geoCoder = CLGeocoder()
    var searchLocationCoordinate: CLLocationCoordinate2D!
    var possibleInsertLocationCoordinate: CLLocation!
    
    let locationImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "pin"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        mapView.isScrollEnabled = false
        return mapView
    }()
    
    var locationTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSMutableAttributedString(string: "Enter a Location", attributes: grey25textAttributes)
        textField.myStandardSetup(cornerRadiusSize: cornerRadiusSize, defaulAttributes: black25textAttributes)
        return textField
    }()
    
    
    var findLocationButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.steelBlue
        button.setTitle("FIND LOCATION", for: .normal)
        button.setTitle("Searching...", for: .selected)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(handleFindButton(_:)), for: .touchUpInside)
        button.layer.cornerRadius = cornerRadiusSize
        button.clipsToBounds = true
        return button
    }()
    
    @objc func handleFindButton(_ sender: UIButton){
        view.endEditing(true)
        
        geoCoder.geocodeAddressString(locationTextField.text ?? "") { [weak self] (clplacement, error) in
            guard let placemarks = clplacement, let location = placemarks.first?.location else {
                print("UNABLE to convert to CLL Coordinates")
                sender.isSelected = false
                return
            }
            self?.globalLocation = location
            DispatchQueue.main.async {[weak self] in
                //print("globalLocation --> \(String(describing: self?.globalLocation))")
                let tempAnnotation = MKPointAnnotation()
                tempAnnotation.coordinate = (self?.globalLocation.coordinate)!
                self?.mapView.addAnnotation(tempAnnotation)
                self?.mapView.setCenter(tempAnnotation.coordinate, animated: false)
            }
        }
    }
    
    @objc func handleRight(){
        let newVC = OpeningController()
        newVC.dataController = dataController
        let temp = CLLocation(latitude: globalLocation.coordinate.latitude, longitude: globalLocation.coordinate.longitude)
        newVC.possibleInsertLocationCoordinate = temp
        navigationController?.pushViewController(newVC, animated: true)
    }
    
    
    func setupNavigationManu(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "NEXT", style: .done, target: self, action: #selector(handleRight))
    }
    
    
    func setupUI(){
        let stackView: UIStackView = {
            let stack = UIStackView()
            stack.axis = .vertical
            stack.alignment = .center
            stack.distribution = .fill
            stack.spacing = 15
            stack.translatesAutoresizingMaskIntoConstraints = false
            return stack
        }()
        
        [locationTextField, findLocationButton].forEach{
            $0.heightAnchor.constraint(equalToConstant: customUIHeightSize).isActive = true
            stackView.addArrangedSubview($0)
        }
        
        
        [stackView, locationImageView, mapView].forEach{view.addSubview($0)}
        NSLayoutConstraint.activate([
            locationImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            locationImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: locationImageView.bottomAnchor, constant: 50),
            locationTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            findLocationButton.widthAnchor.constraint(equalTo: locationTextField.widthAnchor),
            mapView.topAnchor.constraint(equalTo: findLocationButton.bottomAnchor, constant: 15),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
            ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .skyBlue4
        setupNavigationManu()
        setupUI()
        setupNotificationReceiver()
        locationTextField.delegate = self
    }
    
    
    //MARK:- Notification Observer
    func setupNotificationReceiver(){
        NotificationCenter.default.addObserver(self, selector: #selector(locationFound), name: Notification.Name("locationFound"), object: nil)
        //        print("possibleInsertLocationCoordinate ==> \(String(describing: possibleInsertLocationCoordinate))")
    }
    
    
    @objc func locationFound(){
        //        let temp2 = delegate?.getUserLocation()
        //        print("delegate --> \(String(describing: temp2))")
        guard let temp = delegate?.getUserLocation() else { return }
        possibleInsertLocationCoordinate = temp
        delegate?.stopGPS()
        mapView.isHidden = false
        //        print("SearchByMapController --> locationFound --> possibleInsertLocationCoordinate ----> \(String(describing: possibleInsertLocationCoordinate))")
        let coordinate = possibleInsertLocationCoordinate.coordinate
        mapView.region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
    }
}
