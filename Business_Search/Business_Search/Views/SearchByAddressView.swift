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
    
    
    var myTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = " Enter address ...."
        textField.clearButtonMode = .whileEditing
        textField.backgroundColor = .white
        textField.adjustsFontSizeToFitWidth = true
        textField.layer.cornerRadius = 5
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    var myButton: UIButton = {
       let button = UIButton()
        button.setTitle("   Locate Address   ", for: .normal)
        button.backgroundColor = UIColor.blue
        button.layer.cornerRadius = 7
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
//    var myTextView: UITextView = {
//        let textView = UITextView()
//        textView.text = " Please enter address ..."
//        textView.font = UIFont(name: "Georgie", size: 30)
//        textView.textColor = .lightGray
//        textView.sizeToFit()
//        textView.isScrollEnabled = false
//        textView.layer.cornerRadius = 5
//        textView.translatesAutoresizingMaskIntoConstraints = false
//        return textView
//    }()
    
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
    
    var clearButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.steelBlue
        button.setTitle("  Clear  ", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = cornerRadiusSize
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
}

