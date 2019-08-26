//
//  CoreData Structs.swift
//  Business Finder
//
//  Created by admin on 8/25/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

struct FavoriteStruct {
    var id: String
}

struct CategoryStruct {
    var alias: String
    var title: String
    var business: Business
}

struct LocationStruct {
    var latitude        : Double
    var longitude       : Double
    var radius          : Int
    var totalBusinesses : Int
    var businesses      : [BusinessStruct] = []
}

struct BusinessStruct {
    var alias           : String? = nil
    var displayAddress  : String? = nil
    var displayPhone    : String? = nil
    var distance        : Double
    var id              : String
    var imageURL        : String
    var isDelivery      : Bool
    var isFavorite      : Bool
    var isPickup        : Bool
    var latitude        : Double
    var longitude       : Double
    var name            : String
    var price           : String
    var rating          : Double
    var reviewCount     : Int
    var url             : String
    
    var categories      : [CategoryStruct] = []
    var parentLocation  : LocationStruct
}
