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
    private var myLabelAttributedString: NSAttributedString!
    private var originalColor: UIColor!
    private var accessoryType: UITableViewCell.AccessoryType!
    
    var getFavoriteImage: UIImage {return favoriteImage}
    var getMyLabelAttributedString: NSAttributedString {return myLabelAttributedString}
    var getOriginalColor: UIColor {return originalColor}
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
        originalColor = getColor(indexPath: colorIndex)
        accessoryType = .disclosureIndicator
    }
}
