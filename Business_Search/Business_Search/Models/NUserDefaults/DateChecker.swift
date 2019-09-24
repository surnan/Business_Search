//
//  DateChecker.swift
//  Business_Search
//
//  Created by admin on 9/23/19.
//  Copyright © 2019 admin. All rights reserved.
//


import UIKit

class DateChecker {
    var today       = ""
    let dateFormat  = "MM/dd/yyyy"
    var todayConst  : String {
        return AppConstants.today.rawValue
    }
    
    
    //init
    func loadSavedDate(){
        today = UserDefaults.standard.object(forKey: todayConst) as? String ?? ""
    }
    
    func getFormattedDate(date: Date, format: String) -> String {
            let dateformat = DateFormatter()
            dateformat.dateFormat = format
            return dateformat.string(from: date)
    }
    
    
    
    func saveTodayDateIfNecessary(dataController: DataController){
        let formatingDate = getFormattedDate(date: Date(), format: dateFormat)
        if formatingDate == today {
            print("saveTodayDate matches .... \(today)")
            return
        }
        let tempLocation = LocationViewModel(dataController: dataController)
        tempLocation.deleteAllLocations()
        UserDefaults.standard.set(formatingDate, forKey: todayConst)
    }
    
    func resetToday(){
        UserDefaults.standard.set("", forKey: todayConst)
    }
}

