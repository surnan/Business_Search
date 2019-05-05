//
//  File.swift
//  _OnTheMap
//
//  Created by admin on 2/17/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

extension UITextField {
    func myStandardSetup(cornerRadiusSize: CGFloat, defaulAttributes: [NSAttributedString.Key : Any]){
        borderStyle = .roundedRect
        clearButtonMode = .whileEditing
        layer.cornerRadius = cornerRadiusSize
        clipsToBounds = true
        defaultTextAttributes = defaulAttributes
        translatesAutoresizingMaskIntoConstraints = false
    }
}

