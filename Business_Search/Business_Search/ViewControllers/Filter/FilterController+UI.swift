//
//  FilterController+UI.swift
//  Business_Search
//
//  Created by admin on 7/28/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

//class FilterController: UIViewController {
extension FilterController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isFilteredLabel.isHidden = !UserAppliedFilter.shared.isFilterOn
    }
    
    func setupUI(){
        let fullStackView   = viewObject.getFullStack()
        view.addSubview(fullStackView)

        fullStackView.centerToSuperView()
        fullStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75).isActive = true
        
        view.addSubview(isFilteredLabel)
        
        let safe = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            isFilteredLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            isFilteredLabel.topAnchor.constraint(equalTo: safe.topAnchor, constant: 10),
            isFilteredLabel.widthAnchor.constraint(equalTo: safe.widthAnchor)
            ])
    }
}
