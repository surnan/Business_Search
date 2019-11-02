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
    var coordinator: SearchTableType?
    var viewObject              : SearchByMapView!
    var viewModel               : SearchByMapViewModel!
    lazy var pinImageView       = viewObject.pinImageView
    lazy var mapView            = viewObject.mapView
    var locationToForward       = CLLocation()                //Pushing into newController()

    
    lazy var showHideAddressBarButton  : UIButton = {
        let button = UIButton()
        button.backgroundColor = .darkGreen
        button.setTitle("Hide Address Bar", for: .normal)
        button.addTarget(self, action: #selector(handleShowHideAddressBarButton(_:)), for: .touchDown)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func handleShowHideAddressBarButton(_ sender: UIButton){
        show = !show
        if sender.title(for: .normal) == "Hide Address Bar" {
            sender.backgroundColor = .darkBlue
            sender.setTitle("Show Address Bar", for: .normal)
            toggleLocateAddressButton(show: show)
            return
        }
        
        sender.backgroundColor = UIColor.darkGreen
        sender.setTitle("Hide Address Bar", for: .normal)
        toggleLocateAddressButton(show: show)
    }
    
    
    var myButton: UIButton = {
       let button = UIButton()
        button.setTitle("   Locate Address   ", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        button.layer.cornerRadius = 7
        //button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    var show = true {
        didSet {
            //addressBarStack.isHidden = !addressBarStack.isHidden
            addressBarStack.isHidden = show
        }
    }
    
    
    @objc   func handleMyButton(){
//        show = !show
//        toggleLocateAddressButton(show: show)
    }
    
    
    var myTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = " Enter address ...."
        textField.clearButtonMode = .whileEditing
        textField.backgroundColor = .white
        textField.adjustsFontSizeToFitWidth = true
        textField.layer.cornerRadius = 5
        //textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var addressBarStack: UIStackView = {
        var stack = UIStackView()
        stack.spacing = 10
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    
    
    //MARK:- UI
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        mapView.delegate = self
        myButton.addTarget(self, action: #selector(handleMyButton), for: .touchDown)
        setupUI()
    }
    
    var anchorMapTop_SafeAreaTop: NSLayoutConstraint?
    var anchorMapTop_ShiftMapToShowLocateAddressButton: NSLayoutConstraint?
   

    //MARK:- Map Delegate Function
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        locationToForward = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
    }
    
    //MARK:- Move to UI extension
    func toggleLocateAddressButton(show: Bool){
        show ? showAddressButton() : hideAddressButton()
        UIView.animate(withDuration: 0.15,
                       animations: {self.view.layoutIfNeeded()},
                       completion: nil)
    }
    
    func setupUI2(){
        anchorMapTop_ShiftMapToShowLocateAddressButton = mapView.topAnchor.constraint(equalTo: addressBarStack.bottomAnchor, constant: 5)
        anchorMapTop_SafeAreaTop = mapView.topAnchor.constraint(equalTo: showHideAddressBarButton.bottomAnchor)
    }
    
    func hideAddressButton(){
        anchorMapTop_SafeAreaTop?.isActive = false
        anchorMapTop_ShiftMapToShowLocateAddressButton?.isActive = true
    }
    
    func showAddressButton(){
        anchorMapTop_ShiftMapToShowLocateAddressButton?.isActive = false
        anchorMapTop_SafeAreaTop?.isActive = true
    }
    
}

