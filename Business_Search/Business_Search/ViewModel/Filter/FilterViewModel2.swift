//
//  SettingsViewModel2.swift
//  Business_Search
//
//  Created by admin on 8/5/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

struct FilterViewModel2 {
    //Values come from NSUserDefaults not CoreData
    private var textViewText: String!
    var getTextViewText         : String {return textViewText}
    
    private var _radius         : Float!
    var getRadiusFloat          : Float {return _radius}
    var getRadiusString         : String{return "\(Int(_radius))"}
    
    private var maxRadius       : Float!
    var getRadiusMaxFloat       : Float {return maxRadius}
    
    var dollarOne       = false
    var dollarTwo       = false
    var dollarThree     = false
    var dollarFour      = false
    var priceExist      = false
    var favoritesTop    = false
    var minimumRating           = "1.0"
    var getSliderValue: Float!
    
    
    init(maximumSliderValue : Int? = nil) {
        textViewText = UserDefaults.standard.object(forKey: AppConstants.greetingMessage.rawValue) as? String
            ?? "Hi.  This is the Yelp page for a business that I am looking at: "
        self._radius = Float(radius)
        if let maximumSliderValue = maximumSliderValue {
            maxRadius = Float(maximumSliderValue)
        }
        
        UserAppliedFilter.shared.loadFilterStruct()
        
        guard let data = UserAppliedFilter.shared.appliedFilter else {return}
        
        dollarOne = data.dollar1
        dollarTwo   = data.dollar2
        dollarThree = data.dollar3
        dollarFour  = data.dollar4
        
        priceExist  = data.priceExists
        favoritesTop = data.priceExists
        var minimumRatingString = data.minimumRating
        
        getSliderValue = Float(minimumRatingString) ?? 1.0
        
        
    }
}
