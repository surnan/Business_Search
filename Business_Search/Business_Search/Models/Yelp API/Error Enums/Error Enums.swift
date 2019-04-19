//
//  Error Enums.swift
//  Business_Search
//
//  Created by admin on 4/18/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case badURL
    case networkTimeOut //error passed back to main
    case networkConnectionGoodButUnableToConnect
    case connectSuccesfulDownloadDataFail
    case yelpErrorDecoded
    case unableToDecode
    case noDataNoError
}

//Note Yelp will not return error if bad decoder is used on our side
enum YelpAPIError: Error {
    case FIELD_REQUIRED
    case VALIDATION_ERROR
    case UNAUTHORIZED
    case INTERNAL_SERVER_ERROR
    case UNKNOWN_ERROR
}
