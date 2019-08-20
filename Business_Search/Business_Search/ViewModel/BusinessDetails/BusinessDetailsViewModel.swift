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
    private var nameAttributedString        = NSAttributedString()
    var getNameAttributedString: NSAttributedString {return nameAttributedString}
    
    private var addressAttributedString     = NSAttributedString()
    var getAddressAttributedString: NSAttributedString {return addressAttributedString}
    
    private var phoneNumberAttributedString = NSAttributedString()
    var getPhoneNumberAttributedString: NSAttributedString {return phoneNumberAttributedString}
    
    
    private var priceString                 = ""
    var getPriceString: String {return priceString}
    
    private var ratingString                = ""
    var getRatingString: String {return ratingString}
    
    private var url                         : String?
    var getUrlString: String? {return url}
    
    private var latitude                    : Double
    var getLatitude: Double {return latitude}
    
    private var longitude                   : Double
    var getLongitude: Double {return longitude}
    
    init(business: Business) {
        self.business = business
        self.latitude = business.latitude
        self.longitude = business.longitude
        
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
        
        url = business.url ?? ""
        ratingString = "Rating: \(business.rating)"
        if let price = business.price {priceString = "Price: \(price)"}
    }
}
