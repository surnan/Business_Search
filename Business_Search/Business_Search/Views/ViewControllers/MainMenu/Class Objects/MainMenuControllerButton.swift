//
//  MainMenuControllerButton.swift
//  Business_Search
//
//  Created by admin on 7/25/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class MainMenuControllerButton: GenericButton {
    init(title: String, background: UIColor, tag: Int){
        super.init(title: title, titleColor: .white, backgroundColor: background, isCorner: true, tag: tag)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 12
        self.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        self.tag                = tag
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
