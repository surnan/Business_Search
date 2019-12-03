//
//  SearchByMapView.swift
//  Business_Search
//
//  Created by admin on 7/28/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import MapKit

class SearchByMapView{
    var viewModel: SearchByMapViewModel?{
        didSet{
            guard let viewModel = viewModel else {
                print("SearchByMapView.ViewModel = NIL")
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
    
    var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    let pinImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "pin2"))
        imageView.isUserInteractionEnabled = false
        imageView.backgroundColor = .clear
        imageView.contentMode = .center
        // imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    let hideAddressBarTxt = "Maximize Map ⬆︎"
    let showAddressBarTxt = "Enter Address ⬇︎"
    
    let hideAddressColor  = UIColor.dodgerBlue4 //UIColor.darkBlue
    
    let showAddressColor  = UIColor.dodgerBlue4
    
    
    lazy var showHideAddressBarButton : GenericButton = {
       let temp = GenericButton(title: hideAddressBarTxt, titleColor: .white, highlightColor: .dodgerBlue4, backgroundColor: .dodgerBlue4, isCorner: true)
        return temp
    }()
    
    
    var myTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = " Enter address ...."
        textField.clearButtonMode = .whileEditing
        textField.backgroundColor = .white
        textField.adjustsFontSizeToFitWidth = true
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 1
        return textField
    }()
    
    var locateAddressButton: UIButton = {
        let button = UIButton()
        button.setTitle(" GO ", for: .normal)
        button.backgroundColor = .dodgerBlue4
        button.layer.cornerRadius = 7
        return button
    }()
    
    lazy var addressBarStack: UIStackView = {
        var stack = UIStackView()
        stack.spacing = 10
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
}
