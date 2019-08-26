//
//  CoreData Structs.swift
//  Business Finder
//
//  Created by admin on 8/25/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import CoreData

struct FavoriteStruct {
    var id: String
}

struct LocationStruct {
    var latitude        : Double    = 250.0
    var longitude       : Double    = 250.0
    var radius          : Int       = -99
    var totalBusinesses : Int       = -11
    var businesses      : [BusinessStruct] = []
}

struct CategoryStruct {
    var alias: String = ""
    var title: String = ""
    var business: Business?
    
    init(alias: String, title: String) {
        self.alias = alias
        self.title = title
    }
}




struct BusinessStruct {
    var alias           : String = ""
    var displayAddress  : String = ""
    var displayPhone    : String = ""
    var distance        : Double = 0.0
    var id              : String = ""
    var imageURL        : String = ""
    var isDelivery      : Bool = false
    var isFavorite      : Bool = false
    var isPickup        : Bool = false
    var latitude        : Double = 0.0
    var longitude       : Double = 0.0
    var name            : String = ""
    var price           : String = ""
    var rating          : Double = 0.0
    var reviewCount     : Int    = 0
    var url             : String = ""
    
    var categories      : [CategoryStruct] = []
    var parentLocation  : LocationStruct?
    
    init(name: String, displayAddress: String) {
        self.name           = name
        self.displayAddress = displayAddress
    }
}
