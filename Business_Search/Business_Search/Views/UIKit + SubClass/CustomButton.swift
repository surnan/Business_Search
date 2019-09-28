//
//  CustomButton.swift
//  Business_Search
//
//  Created by admin on 6/28/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    override open var isHighlighted: Bool {
        didSet {
            backgroundColor = isSelected ? UIColor.white : UIColor.clear
        }
    }
}
