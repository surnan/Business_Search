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
        if formatingDate == today{
            return true
        }
        UserDefaults.standard.set(formatingDate, forKey: todayNSConst)
        return false
    }

    
    func showMyResultsInNSUserDefaults(){
        let myIndex = [todayNSConst]
        var answers = [(key: String, value: Any)]()
        for item in Array(UserDefaults.standard.dictionaryRepresentation()) {
                        if myIndex.contains(item.key) {
                            answers.append(item)
                        }
        }
        answers.forEach{print($0)}
    }

    
    // Only for testing
    func changeDate(){
        UserDefaults.standard.set("01/01/2001", forKey: todayNSConst)
    }
    
    func resetToday(){
        UserDefaults.standard.set("", forKey: todayNSConst)
    }
}


