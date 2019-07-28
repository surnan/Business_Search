//
//  FilterViewModel.swift
//  Business_Search
//
//  Created by admin on 7/28/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

struct FilterViewModel {
    private var sliderValue: Float!
    var getSliderValue: Float {return sliderValue}
 
    private var minimumRatingText: String!
    var getMinimumRatingText: String {return minimumRatingText}

    
    init(){
        let shared              = UserAppliedFilter.shared
        minimumRatingText   = shared.getMinimumRatingString
        sliderValue         = shared.getMinimumRatingFloat
    }
}
