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
        [distanceSliderStack, verticalSearchStack, textViewStack, saveCancelDeleteStack].forEach{view.addSubview($0)}
        
        let safe = view.safeAreaLayoutGuide
        viewObject.myTextView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        verticalSearchStack.anchor(top: safe.topAnchor, padding: .init(top: 70, left: 0, bottom: 0, right: 0),
                                   centerX: true, x: view.widthAnchor, xMultiply: 0.8)
        textViewStack.anchor(top: verticalSearchStack.bottomAnchor, padding: .init(top: 70, left: 0, bottom: 0, right: 0), centerX: true)
        saveCancelDeleteStack.anchor(top: textViewStack.bottomAnchor, padding: .init(top: 70, left: 0, bottom: 0, right: 0), centerX: true)
    }
}

