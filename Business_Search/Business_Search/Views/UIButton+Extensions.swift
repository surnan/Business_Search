//
//  File2.swift
//  _OnTheMap
//
//  Created by admin on 2/17/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit


extension UIButton {
    func myStandardSetup(cornerRadiusSize: CGFloat, background: UIColor){
        backgroundColor = background
        layer.cornerRadius = cornerRadiusSize
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
    }
}
