//
//  MainMenuViewModel.swift
//  Business_Search
//
//  Created by admin on 9/23/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit


class MainMenuViewModel{
    var dataController: DataController!
    private var today       = ""
    private let dateFormat  = "MM/dd/yyyy"
    private var todayNSConst  : String {
        return AppConstants.today.rawValue
    }
    
    //Init
    init(dataController: DataController) {
        self.dataController = dataController
        today = UserDefaults.standard.object(forKey: todayNSConst) as? String ?? ""
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    private func getFormattedDate(date: Date) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = dateFormat
        return dateformat.string(from: date)
    }
    
    
    func doesDateMatch(date: Date)->Bool{
        let formatingDate = getFormattedDate(date: date)
        if formatingDate == today {
            print("saveTodayDate matches .... \(today)")
            return true
        }
        UserDefaults.standard.set(formatingDate, forKey: todayNSConst)
        return false
    }
    
    
    func showMyResultsInNSUserDefaults2(){
        let myIndex = ["minimumRating", "isFavoritesToTop"]
        var answers = [(key: String, value: Any)]()
        for item in Array(UserDefaults.standard.dictionaryRepresentation()) {
                        if myIndex.contains(item.key) {
                            answers.append(item)
                        }
        }
        let items = Array(UserDefaults.standard.dictionaryRepresentation())
        answers.forEach{print($0)}
        print("\n***\ncount --> \(items.count)")
    }
    
    
    
    
    func showMyResultsInNSUserDefaults(){
        let myIndex = ["dollarOne", "dollarTwo", "dollarThree", "dollarFour", "isPriceListed", "isRatingListed"]
        var answers = [(key: String, value: Any)]()
        for item in Array(UserDefaults.standard.dictionaryRepresentation()) {
//                        if myIndex.contains(item.key) {
//                            answers.append(item)
//                        }
            answers.append(item)
        }
        answers.forEach{print($0)}
    }
    
    
    //    let tempLocation = LocationViewModel(dataController: <#T##DataController#>)
    //    tempLocation.deleteAllLocations()
    //    UserDefaults.standard.set(formatingDate, forKey: todayNSConst)
    
    
    
    // Only for testing
    func resetToday(){
        UserDefaults.standard.set("", forKey: todayNSConst)
    }
}


