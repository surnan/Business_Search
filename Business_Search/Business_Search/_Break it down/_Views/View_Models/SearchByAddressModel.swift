//
//  SearchByAddressModel.swift
//  Business_Search
//
//  Created by admin on 7/22/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import MapKit

class SearchByAddressModel{
    let locationImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "pin"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.region = MKCoordinateRegion(center: possibleInsertLocationCoordinate.coordinate,
                                            latitudinalMeters: 500,
                                            longitudinalMeters: 500)
        //mapView.delegate = self
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
        //button.addTarget(self, action: #selector(handleFindButton(_:)), for: .touchUpInside)
        button.layer.cornerRadius = cornerRadiusSize
        button.clipsToBounds = true
        return button
    }()
    
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 15
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    
    var possibleInsertLocationCoordinate: CLLocation
    init(possibleInsertLocationCoordinate: CLLocation) {
        self.possibleInsertLocationCoordinate = possibleInsertLocationCoordinate
    }
    
    
    func getStackView(){
        [locationTextField, findLocationButton].forEach{
            $0.heightAnchor.constraint(equalToConstant: customUIHeightSize).isActive = true
            stackView.addArrangedSubview($0)
        }

    }
    
    
    
}

