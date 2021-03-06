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
        myTextView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        let myStack: UIStackView = {
            let stack = UIStackView()
            stack.axis = .vertical
            stack.spacing = 50
            stack.translatesAutoresizingMaskIntoConstraints = false
            return stack
        }()
        
        [distanceSliderStack, verticalSearchStack, textViewStack].forEach{myStack.addArrangedSubview($0)}
        let deleteAllLabel = viewObject.getDeleteAllLabel()
        
        [myStack, deleteAllLabel, saveCancelDeleteStack].forEach{view.addSubview($0)}
        
        NSLayoutConstraint.activate([
            myStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            myStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            saveCancelDeleteStack.topAnchor.constraint(equalTo: myStack.bottomAnchor, constant: 20),
            saveCancelDeleteStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            deleteAllLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            deleteAllLabel.topAnchor.constraint(equalTo: saveCancelDeleteStack.bottomAnchor, constant: 15)
            ])
    }
}

