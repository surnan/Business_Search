//
//  MainMenuView.swift
//  Business_Search
//
//  Created by admin on 7/25/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import MapKit

class MainMenuView {
    var nearMeSearchButton      = MainMenuControllerButton(title: "Search Near Me", background: .blue, tag: 0)
    var searchByMapButton       = MainMenuControllerButton(title: "Search By Map", background: .red, tag: 1)
    var searchByAddressButton   = MainMenuControllerButton(title: "     Search By Address     ", background: .green, tag: 2)
    let activityView            = GenericActivityIndicatorView()
    
    let titleImage: UIImageView = {
        let imageView           = UIImageView(image: #imageLiteral(resourceName: "BUSINESS_Finder"))
        imageView.contentMode   = .scaleAspectFit
        return imageView
    }()
    
    func getButtonStack()-> UIStackView{
        let verticalStackView = GenericStack(spacing: 20, distribution: .fillEqually)
        [nearMeSearchButton, searchByMapButton, searchByAddressButton].forEach{
            verticalStackView.addArrangedSubview($0)
        }
        return verticalStackView
    }
}

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
