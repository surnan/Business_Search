//
//  YelpAllCategoriesResponse.swift
//  Business_Search
//
//  Created by admin on 4/22/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation


struct YelpAllCategoriesResponse: Codable {
    struct CategoriesStruct: Codable {
        var alias: String
        var title: String
    }
    var categories: [CategoriesStruct]
}
