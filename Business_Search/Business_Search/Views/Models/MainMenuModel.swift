//
//  MainMenuModel.swift
//  Business_Search
//
//  Created by admin on 6/30/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class MainMenuControllerButton: GenericButton {
    init(title: String, backgroundColor: UIColor, tag: Int){
        super.init(title: title, titleColor: .white, backgroundColor: backgroundColor, isCorner: true, tag: tag)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 12
        self.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        self.tag = tag
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MainMenuModel {
    var nearMeSearchButton = MainMenuControllerButton(title: "Search Near Me", backgroundColor: .blue, tag: 0)
    var searchByMapButton = MainMenuControllerButton(title: "Search By Map", backgroundColor: .red, tag: 1)
    var searchByAddressButton = MainMenuControllerButton(title: "     Search By Address     ", backgroundColor: .green, tag: 2)
    func getMenuButtonStack()-> UIStackView{
        let stack = GenericStack(spacing: 20, distribution: .fillEqually)
        [nearMeSearchButton, searchByMapButton, searchByAddressButton].forEach{stack.addArrangedSubview($0)}
        return stack
    }
}


