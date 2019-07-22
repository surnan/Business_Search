//
//  GoogleMapResponse.swift
//  Business_Search
//
//  Created by admin on 5/31/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

struct GoogleMapResponse: Codable {
    var routes: [RouteStruct]
    
    struct RouteStruct:Codable {
        var legs: [LegStruct]
    }
    
    struct LegStruct: Codable {
        var steps: [StepStruct]
    }
    
    struct StepStruct:Codable {
        var html_instructions: String?
        var steps: [StepStruct]?
        var transit_details: TransitDetailStuct?
    }
    
    struct TransitDetailStuct: Codable {
        var arrival_stop: ArrivalStopStruct
        var line: LineStruct
    }
    
    struct ArrivalStopStruct: Codable {
        var name: String
    }
    
    struct LineStruct: Codable {
        var short_name: String
    }
}
