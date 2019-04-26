//
//  YelpInputDataStruct.swift
//  Business_Search
//
//  Created by admin on 4/25/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation


struct YelpInputDataStruct: Equatable {
    var latitude: Double
    var longitude: Double
    var offset: Int
    
    
    static func == (lhs: YelpInputDataStruct, rhs: YelpInputDataStruct) -> Bool{
        return lhs.offset == rhs.offset
    }
    
    
}
