//
//  SearchByAddressViewModel.swift
//  Business_Search
//
//  Created by admin on 7/28/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class SearchByAddressViewModel{
    private var latitude: Double!
    var getLatitude: Double {return latitude}
    
    private var longitude: Double!
    var getLongitude: Double{return longitude}
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
