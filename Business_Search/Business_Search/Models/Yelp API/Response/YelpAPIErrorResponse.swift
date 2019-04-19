//
//  APIErrorCodes.swift
//  Business_Search
//
//  Created by admin on 4/18/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation


struct YelpAPIErrorResponse: Codable {
    struct ErrorStruct: Codable {
        var code: String
        var description: String
        var field: String
    }
    var error: ErrorStruct
}
