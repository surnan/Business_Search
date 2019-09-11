//
//  CustomButton.swift
//  Business_Search
//
//  Created by admin on 6/28/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class SelectedButton: UIButton {
    override open var isHighlighted: Bool {
        didSet {
            backgroundColor = isSelected ? .white : .clear
        }
    }
}

class HighlightedButton: UIButton {
    override open var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? .clear : .white
        }
    }
}
