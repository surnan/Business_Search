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
    
    var toString: String {
        switch self {
        case .badURL: return "ERROR: Invalid URL"
        case .networkTimeOut:return "ERROR: Network Time Out"
        case .networkConnectionGoodButUnableToConnect:return "ERROR: Unable to connect to Yelp endpoint"
        case .connectSuccesfulDownloadDataFail:return "ERROR: Succesfully connect but unable to download data"
        case .tooManyRequestsPerSecond:return "ERROR: Simultaneous download threshold exceeded"
        case .yelpErrorDecoded:return "ERROR: Unable to decode Yelp downloaded data"
        case .unableToDecode:return "ERROR: Unable to decode downloaded data"
        case .noData_noError:return "ERROR: Data connection failed without error"
        case .needToRetry:return "ERROR:  Retry might succeed"
        }
    }
}


enum YelpAPIError: Error {
    case FIELD_REQUIRED
    case VALIDATION_ERROR
    case UNAUTHORIZED
    case INTERNAL_SERVER_ERROR
    case UNKNOWN_ERROR
}
