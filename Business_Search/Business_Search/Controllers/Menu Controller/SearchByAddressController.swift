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

let cornerRadiusSize: CGFloat = 5.0
let customUIHeightSize: CGFloat = 55

class SearchByAddressController: UIViewController {
    var dataController: DataController!
    
    
    
    var globalLocation = CLLocation()
    let geoCoder = CLGeocoder()
    
    let locationImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "pin"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        mapView.region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 150, longitudinalMeters: 150)
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
        geoCoder.geocodeAddressString(locationTextField.text ?? "") { [weak self] (clplacement, error) in
            guard let placemarks = clplacement, let location = placemarks.first?.location else {
                print("UNABLE to convert to CLL Coordinates")
                sender.isSelected = false
                return
            }
            self?.globalLocation = location
            DispatchQueue.main.async {[weak self] in

                print("globalLocation --> \(String(describing: self?.globalLocation))")
                
                
                /*
 let tempAnnotation = MKPointAnnotation()
 tempAnnotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
 tempAnnotation.title = business.name ?? ""
 annotations.append(tempAnnotation)
 */
                
//                let coordinate = CLLocationCoordinate2D(latitude: (self?.globalLocation.coordinate.latitude)!, longitude: (self?.globalLocation.coordinate.longitude)!)
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
        newVC.searchLocationCoordinate = globalLocation.coordinate
        navigationController?.pushViewController(newVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .skyBlue4
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "NEXT", style: .done, target: self, action: #selector(handleRight))
        
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
    
}