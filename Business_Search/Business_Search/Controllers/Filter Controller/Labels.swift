//
//  Labels.swift
//  Business_Search
//
//  Created by admin on 6/28/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class MyLabel: UILabel {
    init(text: String, size: CGFloat = 12, backgroundColor: UIColor = UIColor.clear, textColor: UIColor = UIColor.white, corner: Bool = false) {
        super.init(frame: .zero)
        self.text = text
        self.font = UIFont.boldSystemFont(ofSize: size)
        self.textColor = .white
        self.textAlignment = .center
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        if corner {
            self.layer.cornerRadius = 10
            self.clipsToBounds = true
        }
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

