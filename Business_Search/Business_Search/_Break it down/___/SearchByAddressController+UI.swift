//
//  SearchByAddressController+UI.swift
//  Business_Search
//
//  Created by admin on 7/22/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit


extension SearchByAddressController{
    func setupUI(){
        let safe = view.safeAreaLayoutGuide
        let stackView = viewObject.getStackView()
        [stackView, locationImageView, mapView].forEach{view.addSubview($0)}
        locationImageView.anchor(top: safe.topAnchor, padding: .init(top: 10, left: 0, bottom: 0, right: 0), centerX: true)
        stackView.anchor(top: locationImageView.bottomAnchor, padding: .init(top: 10, left: 0, bottom: 0, right: 0), centerX: true)
        viewObject.locationTextField.anchor(x: view.widthAnchor, xMultiply: 0.7)
        viewObject.findLocationButton.anchor(x: view.widthAnchor, xMultiply: 0.7)
        mapView.anchor(top: stackView.bottomAnchor, leading: safe.leadingAnchor, trailing: safe.trailingAnchor, bottom: safe.bottomAnchor,
                       padding: .init(top: 10, left: 0, bottom: 0, right: 0))
    }
}
