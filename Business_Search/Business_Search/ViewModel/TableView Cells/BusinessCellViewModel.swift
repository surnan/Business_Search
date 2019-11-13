//
//  MyBusinessCell.swift
//  Business_Search
//
//  Created by admin on 7/24/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreLocation

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
    private var distanceString: String!
    
    var getFavoriteImage: UIImage {return favoriteImage}
    var getMyLabelAttributedString: NSAttributedString {return myLabelAttributedString}
    var getOriginalColor: UIColor {return originalColor}
    var getAccessoryType: UITableViewCell.AccessoryType {return accessoryType}
    var getDistanceString: String {return distanceString}
    
    
    init(business: Business? = nil, favoriteBusiness: FavoriteBusiness? = nil, colorIndex: IndexPath) {
        
        if let business = business {
            if let displayAddress = business.displayAddress,
                let address = displayAddress.split(separator: "?").first,
                let name = business.name {
                let nameNewLine = "\(name)- (m)\(business.distance3)\n"
                let topString = NSMutableAttributedString(string: nameNewLine, attributes: topStringAttributes)
                let bottomString = NSMutableAttributedString(string: String(address), attributes: bottomStringAttributes)
                topString.append(bottomString)
                myLabelAttributedString = topString
                let myDistance = business.distance
                switch myDistance {
                case 0..<30:
                    let metersToFeet = Int(myDistance * 3.28)                   //Meters to Feet
                    distanceString = "\(metersToFeet)\n feet"
                default:
                    let metersToMiles = myDistance * 0.000621371                //Meters to Miles
                    let roundedValue = Double(round(metersToMiles * 100)/100)   // 2-digits after decimal
                    distanceString = "\(roundedValue)\n miles"
                }
            }
            favoriteImage = business.isFavorite ? #imageLiteral(resourceName: "Favorite") : #imageLiteral(resourceName: "UnFavorite")
            originalColor = getColor(indexPath: colorIndex)
            accessoryType = .disclosureIndicator
        }

        if let business = favoriteBusiness {
            if let displayAddress = business.displayAddress,
                let address = displayAddress.split(separator: "?").first,
                let name = business.name {
                let nameNewLine = "\(name)- (m)\(business.distance3)\n"
                let topString = NSMutableAttributedString(string: nameNewLine, attributes: topStringAttributes)
                let bottomString = NSMutableAttributedString(string: String(address), attributes: bottomStringAttributes)
                topString.append(bottomString)
                myLabelAttributedString = topString
                let myDistance = business.distance
                switch myDistance {
                case 0..<30:
                    let metersToFeet = Int(myDistance * 3.28)                   //Meters to Feet
                    distanceString = "\(metersToFeet)\n feet"
                default:
                    let metersToMiles = myDistance * 0.000621371                //Meters to Miles
                    let roundedValue = Double(round(metersToMiles * 100)/100)   // 2-digits after decimal
                    distanceString = "\(roundedValue)\n miles"
                }
            }
            favoriteImage = business.isFavorite ? #imageLiteral(resourceName: "Favorite") : #imageLiteral(resourceName: "UnFavorite")
            originalColor = getColor(indexPath: colorIndex)
            accessoryType = .disclosureIndicator
        }
        
        
        
//        if let favoriteBusiness = favoriteBusiness {
//            if let displayAddress = favoriteBusiness.displayAddress,
//                let address = displayAddress.split(separator: "?").first,
//                let name = favoriteBusiness.name {
//
//                let nameNewLine = "\(name) - (m)\(favoriteBusiness.distance3))\n"
//
//                let topString = NSMutableAttributedString(string: nameNewLine, attributes: topStringAttributes)
//                let bottomString = NSMutableAttributedString(string: String(address), attributes: bottomStringAttributes)
//                topString.append(bottomString)
//                myLabelAttributedString = topString
//            }
//            favoriteImage = favoriteBusiness.isFavorite ? #imageLiteral(resourceName: "Favorite") : #imageLiteral(resourceName: "UnFavorite")
//            originalColor = getColor(indexPath: colorIndex)
//            accessoryType = .disclosureIndicator
//        }
        
        
    }
}
