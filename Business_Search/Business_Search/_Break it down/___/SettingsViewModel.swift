//
//  SettingsViewModel.swift
//  Business_Search
//
//  Created by admin on 7/28/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

struct SettingsViewModel {
    private var textViewText: String!
    var getTextViewText     : String {return textViewText}
    
    private var _radius     : Float!
    var getRadiusFloat      : Float {return _radius}
    var getRadiusString     : String{return "\(Int(_radius))"}
    
    private var maxRadius   : Float!
    var getRadiusMaxFloat   : Float {return maxRadius}
    
    init(maximumSliderValue : Int? = nil) {
        textViewText = ""
        
        self._radius = Float(radius)
        if let maximumSliderValue = maximumSliderValue {
            maxRadius = Float(maximumSliderValue)
        }
    }
}
