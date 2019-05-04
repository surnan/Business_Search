//
//  YelpInputDataStruct.swift
//  Business_Search
//
//  Created by admin on 4/25/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

struct CreateYelpURLDuringLoopingStruct{
    var latitude: Double
    var longitude: Double
    var offset: Int
}
//
//struct YelpCategoryElement: Equatable {
//    var alias: String
//    var title: String
//    var businessID: String
//    static func == (lhs: YelpCategoryElement, rhs: YelpCategoryElement) -> Bool {
//        return lhs.title == rhs.title
//    }
//}
//
//struct YelpBusinessElement {
//    var title: String
//    var address: String
//    var state: String
//    var zipCode: String
//    var businessID: String
//}



/*
 //With this structure and the hard-set values in AppDelegate, URLs can be recreated until all businesses are downloaded
 //This is needed because Yelp limits each pull to max = 50
 struct CreateYelpURLDuringLoopingStruct{
 var latitude: Double
 var longitude: Double
 var offset: Int
 }
 */
