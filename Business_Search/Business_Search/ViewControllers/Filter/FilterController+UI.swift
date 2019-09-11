//
//  FilterController+UI.swift
//  Business_Search
//
//  Created by admin on 7/28/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit


extension FilterController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isFilteredLabel.isHidden = !UserAppliedFilter.shared.isFilterOn
    }
    
    func setupUI(){
        let fullStackView   = viewObject.getFilterOptionStack()
        view.addSubview(fullStackView)
//        fullStackView.centerToSuperView()
        view.addSubview(isFilteredLabel)
        
        let buttonStack = viewObject.getSaveCancelDefaultStack()
        view.addSubview(buttonStack)
        
        let safe = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            isFilteredLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            isFilteredLabel.topAnchor.constraint(equalTo: safe.topAnchor, constant: 10),
            isFilteredLabel.widthAnchor.constraint(equalTo: safe.widthAnchor),
            fullStackView.topAnchor.constraint(equalTo: isFilteredLabel.bottomAnchor, constant: 30),
            fullStackView.widthAnchor.constraint(equalTo: safe.widthAnchor, multiplier: 0.75),
            fullStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonStack.topAnchor.constraint(equalTo: fullStackView.bottomAnchor, constant: 40),
            buttonStack.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
    }
}

