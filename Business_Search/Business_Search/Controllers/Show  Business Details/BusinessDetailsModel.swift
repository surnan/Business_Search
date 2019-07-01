////
////  BusinessDetailsModel.swift
////  Business_Search
////
////  Created by admin on 7/1/19.
////  Copyright © 2019 admin. All rights reserved.
////
//
//import UIKit
//import CoreData
//import MapKit
//import CoreLocation
//
//class BusinessDetailsModel {
//    var business: Business! {
//        didSet {
//            firstAnnotation.coordinate = CLLocationCoordinate2D(latitude: business.latitude, longitude: business.longitude)
//            
//            if let name = business.name {
//                let attributes: [NSAttributedString.Key: Any] = [
//                    .foregroundColor : UIColor.black,
//                    .font: UIFont.boldSystemFont(ofSize: 28),
//                ]
//                nameLabel.attributedText = NSAttributedString(string: name, attributes: attributes)
//            }
//            
//            if let address = business.displayAddress {
//                let replaced = address.replacingOccurrences(of: "?", with: "\n")
//                let attributes: [NSAttributedString.Key: Any] = [
//                    .foregroundColor : UIColor.black,
//                    .font: UIFont(name: "Georgia", size: 25) as Any,
//                ]
//                addressLabel.attributedText = NSAttributedString(string: replaced, attributes: attributes)
//            }
//            
//            
//            if let phoneNumber = business.displayPhone {
//                let phoneText = "tel://\(phoneNumber)"
//                let attributes: [NSAttributedString.Key: Any] = [
//                    .foregroundColor : UIColor.blue,
//                    .font: UIFont(name: "Arial", size: 25) as Any,
//                    // NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
//                ]
//                phoneNumberLabel.attributedText = NSAttributedString(string: phoneText, attributes: attributes)
//            }
//            
//            if let phoneNumber = business.displayPhone {
//                let phoneText = "\(phoneNumber)"
//                let attributes: [NSAttributedString.Key: Any] = [
//                    .foregroundColor : UIColor.blue,
//                    .font: UIFont(name: "Georgia", size: 25) as Any,
//                ]
//                let myNormalAttributedTitle = NSAttributedString(string: phoneText,
//                                                                 attributes: attributes)
//                phoneNumberButton.setAttributedTitle(myNormalAttributedTitle, for: .normal)
//            }
//            
//            if let price = business.price {
//                priceLabel.text = "Price: \(price)"
//            }
//            ratingLabel.text = "\nRating: \(business.rating)"
//        }
//    }
//    
//    
//    var nameLabel           = GenericLabel(text: "", size: 16, textColor: .black)
//    var addressLabel        = GenericLabel(text: "", size: 16, textColor: .black)
//    var phoneNumberlabel    = GenericLabel(text: "", size: 16, textColor: .black)
//    
//    
//    var websiteButton   = GenericButton(title: "  Visit Yelp Page  ", titleColor: .white, backgroundColor: .blue, isCorner: true)
//    
//    
//
//    
//    
//    
//    
//    
//    
//    
//    
//}
