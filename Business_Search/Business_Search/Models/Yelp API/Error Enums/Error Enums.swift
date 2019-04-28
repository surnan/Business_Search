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
    case networkTimeOut
    case networkConnectionGoodButUnableToConnect
    case connectSuccesfulDownloadDataFail
    case tooManyRequestsPerSecond
    case yelpErrorDecoded
    case unableToDecode
    case noData_noError
    case needToRetry
}


enum YelpAPIError: Error {
    case FIELD_REQUIRED
    case VALIDATION_ERROR
    case UNAUTHORIZED
    case INTERNAL_SERVER_ERROR
    case UNKNOWN_ERROR
}
