//
//  BusinessDetailsViewModel.swift
//  Business_Search
//
//  Created by admin on 7/26/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

struct BusinessDetailsViewModel {
    private var business: Business
    var nameAttributedString        = NSAttributedString()
    var addressAttributedString     = NSAttributedString()
    var phoneNumberAttributedString = NSAttributedString()
    var priceString                 = ""
    var ratingString                = ""
    var url                         : String?
    
    
    init(business: Business) {
        self.business = business
        
        if let name = business.name {
            let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor : UIColor.black,
                .font: UIFont.boldSystemFont(ofSize: 28),
            ]
            nameAttributedString = NSAttributedString(string: name, attributes: attributes)
        }
        
        if let address = business.displayAddress {
            let replaced = address.replacingOccurrences(of: "?", with: "\n")
            let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor : UIColor.black,
                .font: UIFont(name: "Georgia", size: 25) as Any,
            ]
            addressAttributedString = NSAttributedString(string: replaced, attributes: attributes)
        }
        
        if let phoneNumber = business.displayPhone {
            let phoneText = "tel://\(phoneNumber)"
            let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor : UIColor.blue,
                .font: UIFont(name: "Arial", size: 25) as Any,
                // NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
            ]
            phoneNumberAttributedString = NSAttributedString(string: phoneText, attributes: attributes)
        }
        
        if let phoneNumber = business.displayPhone {
            let phoneText = "\(phoneNumber)"
            let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor : UIColor.blue,
                .font: UIFont(name: "Georgia", size: 25) as Any,
            ]
            phoneNumberAttributedString = NSAttributedString(string: phoneText,
                                                             attributes: attributes)
        }
        
        self.url = business.url ?? ""
        
        if let price = business.price {priceString = "Price: \(price)"}
        ratingString = "\nRating: \(business.rating)"
    }
}
