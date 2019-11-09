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
    
    var nearMeSearchButton      = MainMenuControllerButton(title: "Nearby Businesses", background: .blue, tag: 0)
    var searchByMapButton       = MainMenuControllerButton(title: "Specify Location", colorLiteral: .red, tag: 1)
    var searchByAddressButton   = MainMenuControllerButton(title: "Show Favorites", colorLiteral: #colorLiteral(red: 0.09385261685, green: 0.4720010757, blue: 0.2862769961, alpha: 1), tag: 2)
    
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
    
    func getNearMeButton()->UIButton{
        return nearMeSearchButton
    }
    
    func getByMapButton()->UIButton{
        return searchByMapButton
    }
    
    func getByAddressButton()->UIButton{
        return searchByAddressButton
    }
}



class MainMenuControllerButton: GenericButton {
    init(title: String, background: UIColor = UIColor.clear, colorLiteral: UIColor = UIColor.clear, tag: Int){
        
        let bColor = background != .clear ? background : colorLiteral
        
        
        super.init(title: title, titleColor: .white, backgroundColor: bColor, tag: tag)
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor : UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 20),
        ]
        
        
        
        let newTitle = NSAttributedString(string: title, attributes: attributes)
        self.setAttributedTitle(newTitle, for: .normal)
        self.layer.cornerRadius = 15
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
