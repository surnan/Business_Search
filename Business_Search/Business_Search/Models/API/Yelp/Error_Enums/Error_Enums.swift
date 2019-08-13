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
        case .networkConnectionGoodButUnableToConnect:return "Unable to connect to Yelp endpoint"
        case .connectSuccesfulDownloadDataFail:return "Succesfully connect but unable to download data"
        case .tooManyRequestsPerSecond:return "Simultaneous download threshold exceeded"
        case .yelpErrorDecoded:return "Unable to decode Yelp downloaded data"
        case .unableToDecode:return "Unable to decode downloaded data"
        case .noData_noError:return "Data connection failed without error"
        case .needToRetry:return "Retry might succeed"
        }
    }
}


enum YelpAPIError: Error {
    case FIELD_REQUIRED
    case VALIDATION_ERROR
    case UNAUTHORIZED
    case INTERNAL_SERVER_ERROR
    case UNKNOWN_ERROR
    case OUT_Of_LICENSES
    
    var toString: String {
        switch self {
        case .INTERNAL_SERVER_ERROR: return "Yelp Internal Server Error"
        case .OUT_Of_LICENSES: return "Daily network calls for this license reached"
        case .UNAUTHORIZED: return "This application is currently not authorized to accessed Yelp data"
        case .VALIDATION_ERROR: return "Authorization Error"
        case .FIELD_REQUIRED: return "Incomplete fields in data request"
        case .UNKNOWN_ERROR: return "Unknown Yelp error"
        }
    }
}
