//
//  SettingsController.swift
//  Business_Search
//
//  Created by admin on 5/23/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData


class SettingsController: UIViewController, NSFetchedResultsControllerDelegate {
    var dataController      : DataController!           //injected
    var delegate            : UnBlurViewProtocol?   //Unblur
    var newRadiusValue      : Int!
    var maximumSliderValue  : Int?
    
    var coordinator         : Coordinator?
    
    lazy var fetchLocation  = LocationNSFetchController(dataController: dataController)
    lazy var model          = SettingsModel(maximumSliderValue: maximumSliderValue)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .clear
        view.isOpaque = false
        setupUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addHandlers()
        fetchLocation.controller?.delegate = self
    }
    
    func setupUI(){
        let saveCancelDeleteStack   = model.getSaveCancelStack()
        let textViewStack           = model.getTextViewStack()
        let distanceSliderStack     = model.getDistanceSliderStack()
        let verticalSearchStack     = model.getSearchStack()
        [distanceSliderStack, verticalSearchStack, textViewStack, saveCancelDeleteStack].forEach{view.addSubview($0)}
        NSLayoutConstraint.activate([
            model.myTextView.heightAnchor.constraint(equalToConstant: 50),
            verticalSearchStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70),
            verticalSearchStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            verticalSearchStack.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            textViewStack.topAnchor.constraint(equalTo: verticalSearchStack.bottomAnchor, constant: 70),
            textViewStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveCancelDeleteStack.topAnchor.constraint(equalTo: textViewStack.bottomAnchor, constant: 70),
            saveCancelDeleteStack.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
    }
    
    func addHandlers(){
        model.distanceSlider.addTarget(self, action: #selector(handleSliderValueChange(_:forEvent:)), for: .valueChanged)
        model.saveButton.addTarget(self, action: #selector(handleSaveButton), for: .touchUpInside)
        model.cancelButton.addTarget(self, action: #selector(handlecancelButton), for: .touchUpInside)
        model.defaultsButton.addTarget(self, action: #selector(handleDefaultsButton), for: .touchUpInside)
    }
    
    //MARK:- Handlers
    @objc func handleDefaultsButton(){
        fetchLocation.deleteAllLocations()
        self.model.deleteAllLabel.isHidden = false
    }
    
    @objc func handleSliderValueChange(_ sender: UISlider, forEvent event: UIEvent){
        newRadiusValue = Int(sender.value)
        model.sliderValueLabel.text = "\(Int(sender.value))"
    }
    
    @objc func handlecancelButton(){
        dismiss(animated: true) {
            self.delegate?.undoBlur()
        }
    }
    
    @objc func handleSaveButton(){
        if let newRadius = newRadiusValue {
            radius = newRadius
            fetchLocation.deleteAllLocations()
            UserDefaults.standard.set(radius, forKey: AppConstants.radius.rawValue)
            UserDefaults.standard.set(model.myTextView.text, forKey: AppConstants.greetingMessage.rawValue)
        }
        dismiss(animated: true) {
            self.delegate?.undoBlur()
        }
    }
}
