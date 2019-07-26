//
//  CLLocation+Extension.swift
//  Business_Search
//
//  Created by admin on 7/26/19.
//  Copyright © 2019 admin. All rights reserved.
//

import MapKit
import Foundation

extension CLLocation {
    func toDoubles()->(latitude: Double, longitude: Double){
        return (coordinate.latitude, coordinate.longitude)
    }
}
