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

    func setupUI(){
        let fullStackView   = viewObject.getFullStack()
        view.addSubview(fullStackView)

        fullStackView.centerToSuperView()
        fullStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75).isActive = true
    }
}
