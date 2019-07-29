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

    private var dollarOneButtonSelected: Bool!
    var getDollarOneButtonSelected: Bool {return dollarOneButtonSelected}
    
    private var dollarTwoButtonSelected: Bool!
    var getDollarTwoButtonSelected: Bool {return dollarTwoButtonSelected}
    
    private var dollarThreeButtonSelected: Bool!
    var getDollarThreeButtonSelected: Bool {return dollarThreeButtonSelected}
    
    private var dollarFourButtonSelected: Bool!
    var getDollarFourButtonSelected: Bool {return dollarFourButtonSelected}
    
    private var noPriceSwitchIsOn: Bool!
    var getNoPriceSwitchIsOn: Bool {return noPriceSwitchIsOn}
    
    private var favoritesAtTop: Bool!
    var getFavoritesAtTop: Bool {return favoritesAtTop}
    

    init(){
        let shared          = UserAppliedFilter.shared
        minimumRatingText   = shared.getMinimumRatingString
        sliderValue         = shared.getMinimumRatingFloat
        
        
        
        dollarOneButtonSelected    = shared.getOne
        dollarTwoButtonSelected    = shared.getTwo
        dollarThreeButtonSelected  = shared.getThree
        dollarFourButtonSelected   = shared.getFour
        noPriceSwitchIsOn          = shared.getNoPrice
        favoritesAtTop             = shared.getFavoritesAtTop
    }
}
