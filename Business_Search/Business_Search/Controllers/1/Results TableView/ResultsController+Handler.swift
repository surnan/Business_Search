//
//  ResultsController+Handler.swift
//  Business_Search
//
//  Created by admin on 4/18/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

extension ResultsController {
    func handleUpdateSearchResult(data: AutoCompleteResponse?, error: Error?){
        if let err = error {
            print("Error:\n\(err)")
            return
        }
        guard let data = data else {
            print("No Error and No Data")
            return
        }
        
        //tableViewArray.removeAll()    //crash
        tableViewArray[IndexOf.business.rawValue].removeAll()
        tableViewArray[IndexOf.categories.rawValue].removeAll()
        
        data.businesses.forEach{tableViewArray[IndexOf.business.rawValue].append(BusinessesStruct(id: $0.id, name: $0.name))}
        
        //Yelp will sometimes return categories that don't contain substring
        data.categories.forEach { (element) in
            if element.title.contains(inputString){
                tableViewArray[IndexOf.categories.rawValue].append(CategoriesStruct(alias: element.alias, title: element.title))
            }
        }
        tableView.reloadData()
    }
}
