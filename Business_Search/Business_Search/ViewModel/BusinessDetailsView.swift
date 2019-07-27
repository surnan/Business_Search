//
//  BusinessDetailsView.swift
//  Business_Search
//
//  Created by admin on 7/26/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import MapKit

class BusinessDetailsView: UIView {
    
    var mapView             = GenericMapView(isZoom: false, isScroll: false)
    var firstAnnotation     = MKPointAnnotation()
    
    var viewModel: BusinessDetailsViewModel? {
        didSet {
            nameLabel.attributedText        = viewModel?.nameAttributedString
            addressLabel.attributedText     = viewModel?.addressAttributedString
            phoneNumberLabel.attributedText = viewModel?.phoneNumberAttributedString
            phoneNumberButton.setAttributedTitle(viewModel?.phoneNumberAttributedString, for: .normal)
            priceLabel.text                 = viewModel?.priceString
            ratingLabel.text                = viewModel?.ratingString
        }
    }
    
    
    var ratingLabel         = GenericLabel(text: "", size: 16, textColor: .black)
    var priceLabel          = GenericLabel(text: "", size: 16, textColor: .black)
    var nameLabel           = GenericLabel(text: "", size: 16, textColor: .black)
    var addressLabel        = GenericLabel(text: "", size: 16, textColor: .black)
    var phoneNumberLabel    = GenericLabel(text: "", size: 16, textColor: .black)
    var phoneNumberButton   = GenericButton(title: "...", titleColor: .blue, backgroundColor: .white, isCorner: true)
    var visitYelpPageButton = GenericButton(title: "Visit Yelp Page", titleColor: .white, backgroundColor: .blue, isCorner: true)
    var mapItButton         = GenericButton(title: " MAP IT ", titleColor: .white, backgroundColor: .red, isCorner: true)
    
    func getFullStack()->UIStackView {
        let buttonStack = GenericStack(spacing: 5)
        [addressLabel, phoneNumberButton, ratingLabel, priceLabel].forEach{buttonStack.addArrangedSubview($0)}
        return buttonStack
    }
    
    func getButtonStack()-> UIStackView {
        let buttonStack = GenericStack(spacing: 5)
        [visitYelpPageButton, mapItButton].forEach{buttonStack.addArrangedSubview($0)}
        return buttonStack
    }
}
