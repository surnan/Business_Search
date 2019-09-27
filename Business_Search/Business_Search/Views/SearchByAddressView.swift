//
//  SearchByAddressView.swift
//  Business_Search
//
//  Created by admin on 7/28/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import MapKit

class SearchByAddressView {
    var viewModel: SearchByAddressViewModel?{
        didSet{
            guard let viewModel = viewModel else {
                print("SearchByAddressView.viewModel = NIL")
                return
            }
            mapView.region = MKCoordinateRegion(center: .init(latitude: viewModel.getLatitude, longitude: viewModel.getLongitude),
                                                latitudinalMeters: 500,
                                                longitudinalMeters: 500)
        }
    }
    
    let redView: UIView = {
        let myView = UIView()
        myView.backgroundColor = UIColor.lightRed
        myView.translatesAutoresizingMaskIntoConstraints = false
        return myView
    }()
    
    let locationImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "roundPin128"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    var myTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Please enter address ..."
        textView.font = UIFont(name: "Georgie", size: 25)
        textView.textColor = .lightGray
        textView.sizeToFit()
        textView.isScrollEnabled = false
        textView.layer.cornerRadius = 5
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.isScrollEnabled = false
        return mapView
    }()
    
    var locationTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSMutableAttributedString(string: "Enter a Location",
                                                                    //attributes: grey25textAttributes)
            attributes: georgiaAttributes(color: .gray, size: 18))
        textField.myStandardSetup(cornerRadiusSize: cornerRadiusSize, defaulAttributes: black25textAttributes)
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 1
        return textField
    }()
    
    var findLocationButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.steelBlue
        button.setTitle("FIND LOCATION", for: .normal)
        button.setTitle("Searching...", for: .highlighted)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = cornerRadiusSize
        button.clipsToBounds = true
        return button
    }()
    
    func getStackView()-> UIStackView{
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
        
        return stackView
    }
}

