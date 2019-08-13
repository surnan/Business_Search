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
    /////
    case YELP_FIELD_REQUIRED
    case YELP_VALIDATION_ERROR
    case YELP_UNAUTHORIZED
    case YELP_INTERNAL_SERVER_ERROR
    case YELP_UNKNOWN_ERROR
    case YELP_OUT_Of_LICENSES
    
    var toString: String {
        switch self {
        case .badURL                                    : return "ERROR: Invalid URL"
        case .networkTimeOut                            : return "ERROR: Network Time Out"
        case .networkConnectionGoodButUnableToConnect   : return "Unable to connect to Yelp endpoint"
        case .connectSuccesfulDownloadDataFail          : return "Succesfully connect but unable to download data"
        case .tooManyRequestsPerSecond                  : return "Simultaneous download threshold exceeded"
        case .yelpErrorDecoded                          : return "Unable to decode Yelp downloaded data"
        case .unableToDecode                            : return "Unable to decode downloaded data"
        case .noData_noError                            : return "Data connection failed without error"
        case .needToRetry                               : return "Retry might succeed"
        /////
        case .YELP_INTERNAL_SERVER_ERROR                : return "Yelp: Internal Server Error"
        case .YELP_OUT_Of_LICENSES                      : return "Yelp: Daily network calls for this license reached"
        case .YELP_UNAUTHORIZED                         : return "Yelp: This application is currently not authorized to accessed Yelp data"
        case .YELP_VALIDATION_ERROR                     : return "Yelp: Authorization Error"
        case .YELP_FIELD_REQUIRED                       : return "Yelp: Incomplete fields in data request"
        case .YELP_UNKNOWN_ERROR                        : return "Yelp: Unknown Error"
        }
    }
}


enum YelpAPIError: Error {
    case YELP_FIELD_REQUIRED
    case YELP_VALIDATION_ERROR
    case YELP_UNAUTHORIZED
    case YELP_INTERNAL_SERVER_ERROR
    case YELP_UNKNOWN_ERROR
    case YELP_OUT_Of_LICENSES
    
    var toString: String {
        switch self {
        case .YELP_INTERNAL_SERVER_ERROR: return "Yelp: Internal Server Error"
        case .YELP_OUT_Of_LICENSES: return "Yelp: Daily network calls for this license reached"
        case .YELP_UNAUTHORIZED: return "Yelp: This application is currently not authorized to accessed Yelp data"
        case .YELP_VALIDATION_ERROR: return "Yelp: Authorization Error"
        case .YELP_FIELD_REQUIRED: return "Yelp: Incomplete fields in data request"
        case .YELP_UNKNOWN_ERROR: return "Yelp: Unknown Error"
        }
    }
}
