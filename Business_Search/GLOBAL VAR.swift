//
//  GLOBAL VAR.swift
//  Business_Search
//
//  Created by admin on 7/5/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

let limit = 50
var offset = 50
var radius = 350           // NSUserDefaults

var recordCountAtLocation = 0
var categoryMatch = 0
var yelpMaxPullCount = 1000

let businessCellID = "businessCellID"
let _businessCellID = "_businessCellID"
let categoryCellID = "categoryCellID"

enum TableIndex:Int { case business = 0, category }


enum AppConstants:String {
    case limit, offset, radius, recordCountAtLocation, yelpMaxPullCount, dollarOne, dollarTwo, dollarThree, dollarFour, isPriceListed, isRatingListed, minimumRating, greetingMessage
}


let colorArray: [UIColor] = [ .lemonChiffon, .paleGreen, .white, .solidOrange,
                              .grey227, .darkOrange, .greyOrange, .skyBlue4,
                              .lightGray, .plum, .white, .tan,
                              .ghostWhite, .teal, .steelBlue, .snowHalf, .steelBlue4]
