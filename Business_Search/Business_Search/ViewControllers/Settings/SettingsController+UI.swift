//
//  SettingsController+UI.swift
//  Business_Search
//
//  Created by admin on 7/28/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

extension SettingsController{
    func setupUI(){
        let saveCancelDeleteStack   = viewObject.getSaveCancelStack()
        let textViewStack           = viewObject.getTextViewStack()
        let distanceSliderStack     = viewObject.getDistanceSliderStack()
        let verticalSearchStack     = viewObject.getSearchStack()
        

        viewObject.myTextView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        let myStack: UIStackView = {
            let stack = UIStackView()
            stack.axis = .vertical
            stack.spacing = 50
            stack.translatesAutoresizingMaskIntoConstraints = false
            return stack
        }()
        
        [distanceSliderStack, verticalSearchStack, textViewStack, saveCancelDeleteStack].forEach{myStack.addArrangedSubview($0)}
        
        let deleteAllLabel = viewObject.getDeleteAllLabel()
        
        view.addSubview(myStack)
        view.addSubview(deleteAllLabel)
        
        NSLayoutConstraint.activate([
            myStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            myStack.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            deleteAllLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            deleteAllLabel.topAnchor.constraint(equalTo: myStack.bottomAnchor, constant: 15)
            ])
    }
}

