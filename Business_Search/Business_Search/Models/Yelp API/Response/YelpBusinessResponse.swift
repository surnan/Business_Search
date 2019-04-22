//
//  YelpBusinessResponse.swift
//  Business_Search
//
//  Created by admin on 4/19/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

struct YelpBusinessResponse: Codable {
    
    struct CategoriesStruct: Codable {
        var alias: String?
        var title: String?
    }
    
    struct BusinessesStruct: Codable{
        struct CoordinatesStruct: Codable {
            var latitude: Double
            var longitude: Double
        }
        
        struct LocationStruct: Codable {
            var address1: String?
            var adddress2: String?
            var address3: String?
            var city: String?
            var zip_code: String?
            var state: String?
            var display_address: [String]
        }
        
        var id: String?
        var alias: String?
        var name: String?
        var image_url: String?
        var is_closed: Bool?
        var url: String?
        var review_count: Int?
        
        var categories: [CategoriesStruct]
        var rating: Double?
        var coordinates: CoordinatesStruct
        var price: String?
        var location: LocationStruct
        var phone: String?
        var display_phone: String?
        var distance: Double?
    }
    
    var businesses: [BusinessesStruct]
    
    struct CenterStruct: Codable {
        var longitude: Double
        var latitude: Double
    }
    
    struct RegionStruct: Codable {
        var center: CenterStruct
    }
    
    var total: Int
    var region: RegionStruct
}

