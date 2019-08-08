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
    case limit, offset, radius, recordCountAtLocation, yelpMaxPullCount, dollarOne, dollarTwo, dollarThree, dollarFour, isPriceListed, minimumRating, greetingMessage, isFavoritesToTop
}

let offWhite = #colorLiteral(red: 0.9411764706, green: 0.9411764706, blue: 0.9411764706, alpha: 1)
let colorArray: [UIColor] = [ .steelBlue4, #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1), #colorLiteral(red: 0.5808190107, green: 0.0884276256, blue: 0.3186392188, alpha: 1), #colorLiteral(red: 1, green: 0.2527923882, blue: 1, alpha: 1), #colorLiteral(red: 0.476841867, green: 0.5048075914, blue: 1, alpha: 1), #colorLiteral(red: 0.4513868093, green: 0.9930960536, blue: 1, alpha: 1), .teal, #colorLiteral(red: 0.4542378187, green: 0.9083048701, blue: 0.6431113482, alpha: 1), .plum, .paleGreen, .skyBlue4, .tan, .steelBlue, #colorLiteral(red: 0.927500844, green: 0.6378426552, blue: 0.6347927451, alpha: 1), #colorLiteral(red: 0.4094321132, green: 0.271243155, blue: 0.6080636978, alpha: 1)]

func getColor(indexPath: IndexPath)->UIColor{
    if indexPath.row % 2 == 0 {return offWhite}
    let colorIndex = (indexPath.row / 2) % colorArray.count
    return colorArray[colorIndex]
}


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
