//
//  AutoCompleteResponse.swift
//  Business_Search
//
//  Created by admin on 4/16/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

struct AutoCompleteResponse: Codable {
    struct BusinessesStruct: Codable {
        var id: String
        var name: String
    }
    
    struct CategoriesStruct: Codable {
        var alias: String
        var title: String
    }
    
    struct TermsStruct: Codable {
        var text: String
    }
    
    var businesses: [BusinessesStruct]
    var categories: [CategoriesStruct]
    var terms: [TermsStruct]
}
