//
//  Global Variables.swift
//  Business_Search
//
//  Created by admin on 7/5/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

let limit = 50
var offset = 50
var radius = 350           // NSUserDefaults

let cornerRadiusSize: CGFloat = 5.0
let customUIHeightSize: CGFloat = 55

var recordCountAtLocation = 0
var categoryMatch = 0
var yelpMaxPullCount = 1000

let businessCellID = "businessCellID"
let categoryCellID = "categoryCellID"

enum TableIndex:Int { case business = 0, category }


enum AppConstants:String {
    case limit, offset, radius, recordCountAtLocation, yelpMaxPullCount, dollarOne, dollarTwo, dollarThree, dollarFour, isPriceListed, isRatingListed, minimumRating, greetingMessage
}


let colorArray: [UIColor] = [ .lemonChiffon, .paleGreen, .white, .solidOrange,
                              .grey227, .darkOrange, .greyOrange, .skyBlue4,
                              .lightGray, .plum, .white, .tan,
                              .ghostWhite, .teal, .steelBlue, .snowHalf, .steelBlue4]


let grey25textAttributes: [NSAttributedString.Key: Any] = [
    NSAttributedString.Key.foregroundColor : UIColor.gray,
    NSAttributedString.Key.font: UIFont(name: "Georgia", size: 25) as Any
]

let black25textAttributes: [NSAttributedString.Key: Any] = [
    NSAttributedString.Key.foregroundColor : UIColor.black,
    NSAttributedString.Key.font: UIFont(name: "Georgia", size: 25) as Any
]

let white25textAttributes: [NSAttributedString.Key: Any] = [
    NSAttributedString.Key.foregroundColor : UIColor.white,
    NSAttributedString.Key.font: UIFont(name: "Georgia", size: 25) as Any
]

let steelBlue4_25 : [NSAttributedString.Key: Any] = [
    NSAttributedString.Key.foregroundColor : UIColor.steelBlue4,
    NSAttributedString.Key.font: UIFont(name: "Georgia", size: 25) as Any
]

let orange_25 : [NSAttributedString.Key: Any] = [
    NSAttributedString.Key.foregroundColor : UIColor.orange,
    NSAttributedString.Key.font: UIFont(name: "Georgia", size: 25) as Any
]

let whiteHelvetica_20_blackStroke : [NSAttributedString.Key: Any] = [
    NSAttributedString.Key.foregroundColor : UIColor.white,
    NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 20)!,
    NSAttributedString.Key.strokeWidth: -2.6,
    NSAttributedString.Key.strokeColor: UIColor.black
]

let greenHelvetica_30_greyStroke : [NSAttributedString.Key: Any] = [
    NSAttributedString.Key.strokeColor: UIColor.lightGray,
    NSAttributedString.Key.foregroundColor: UIColor.green,
    NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 30)!,
    NSAttributedString.Key.strokeWidth: -1.0
]
