//
//  MyBusinessCell.swift
//  Business_Search
//
//  Created by admin on 7/24/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

struct BusinessCellViewModel {
    private let topStringAttributes: [NSAttributedString.Key: Any]   = [
        .font:UIFont.boldSystemFont(ofSize: 16),
        .strokeColor:UIColor.blue
    ]
    
    private let bottomStringAttributes: [NSAttributedString.Key: Any] = [
        .font:UIFont.italicSystemFont(ofSize: 13),
        .strokeColor : UIColor.darkGray
    ]
    
    private var favoriteImage: UIImage!
    var getFavoriteImage: UIImage {return favoriteImage}
    
    private var myLabelAttributedString: NSAttributedString!
    var getMyLabelAttributedString: NSAttributedString {return myLabelAttributedString}
    
    private var originalColor: UIColor!
    var getOriginalColor: UIColor {return originalColor}
    
    private var accessoryType: UITableViewCell.AccessoryType!
    var getAccessoryType: UITableViewCell.AccessoryType {return accessoryType}
    
    
    init(business: Business, colorIndex: IndexPath) {
        if let displayAddress = business.displayAddress,
            let address = displayAddress.split(separator: "?").first,
            let name = business.name {
            let nameNewLine = "\(name)\n"
            let topString = NSMutableAttributedString(string: nameNewLine, attributes: topStringAttributes)
            let bottomString = NSMutableAttributedString(string: String(address), attributes: bottomStringAttributes)
            topString.append(bottomString)
            myLabelAttributedString = topString
        }
        favoriteImage = business.isFavorite ? #imageLiteral(resourceName: "Favorite") : #imageLiteral(resourceName: "UnFavorite")
        originalColor = colorArray[colorIndex.row % colorArray.count]
        accessoryType = .disclosureIndicator
    }
}
