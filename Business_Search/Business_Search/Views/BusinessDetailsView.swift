//
//  BusinessDetailsView.swift
//  Business_Search
//
//  Created by admin on 7/26/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import MapKit

class BusinessDetailsView {
    var mapView             = GenericMapView(isZoom: true, isScroll: true)
    private var firstAnnotation     = MKPointAnnotation()
    
    var viewModel: BusinessDetailsViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                print("BusinessDetailsView.viewModel = NIL")
                return
            }
            nameLabel.attributedText                = viewModel.getNameAttributedString
            addressLabel.attributedText             = viewModel.getAddressAttributedString
            priceLabel.text                         = viewModel.getPriceString
            ratingLabel.text                        = viewModel.getRatingString
            firstAnnotation.coordinate.latitude     = viewModel.getLatitude
            firstAnnotation.coordinate.longitude    = viewModel.getLongitude
            mapView.addAnnotation(firstAnnotation)
            mapView.region = MKCoordinateRegion(center: .init(latitude: viewModel.getLatitude,
                                                              longitude: viewModel.getLongitude),
                                                latitudinalMeters: 400.0,
                                                longitudinalMeters: 400.0)
            phoneNumberButton.setAttributedTitle(viewModel.getPhoneNumberAttributedString, for: .normal)
        }
    }
    
    let redView: UIView = {
        let myView = UIView()
        myView.backgroundColor = UIColor.lightRed
        myView.translatesAutoresizingMaskIntoConstraints = false
        return myView
    }()
    
    private var ratingLabel         = GenericLabel(text: "", size: 16, textColor: .black)
    private var priceLabel          = GenericLabel(text: "", size: 16, textColor: .black)
    private var addressLabel        = GenericLabel(text: "", size: 16, textColor: .black)
    var nameLabel           = GenericLabel(text: "", size: 16, textColor: .black)
    var phoneNumberButton   = GenericButton(title: "", titleColor: .blue, backgroundColor: .white, isCorner: true)
    var visitYelpPageButton = GenericButton(title: "Visit Yelp Page", titleColor: .white, backgroundColor: .blue, isCorner: true)
    var directionsButton         = GenericButton(title: " Get Directions ", titleColor: .white, backgroundColor: .red, isCorner: true)
    var markFavoriteButton  = GenericButton(title: "---", titleColor: .white, backgroundColor: .green, isCorner: true)
    
    func getFullStack()->UIStackView {
        let buttonStack = GenericStack(spacing: 5)
        [addressLabel, phoneNumberButton, ratingLabel, priceLabel].forEach{buttonStack.addArrangedSubview($0)}
        return buttonStack
    }
    
    func getButtonStack()-> UIStackView {
        let buttonStack = GenericStack(spacing: 10)
        [visitYelpPageButton, directionsButton, markFavoriteButton].forEach{buttonStack.addArrangedSubview($0)}
        return buttonStack
    }
}
