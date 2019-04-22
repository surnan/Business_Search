//
//  ResultsController+Handler.swift
//  Business_Search
//
//  Created by admin on 4/18/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

extension ResultsController {
    func handleUpdateSearchResult(result: Result<YelpAutoCompleteResponse, NetworkError>){
        
        switch result {
        case .failure(let error):
            print("-->Error (localized): \(error.localizedDescription)\n-->Error (Full): \(error)")
        case .success(let data):
                //tableViewArray.removeAll()    //crash
                tableViewArray[IndexOf.business.rawValue].removeAll()
                tableViewArray[IndexOf.categories.rawValue].removeAll()
                
                data.businesses.forEach{tableViewArray[IndexOf.business.rawValue].append(BusinessesStructForArray(id: $0.id, name: $0.name))}
                
                //Yelp will sometimes return categories that don't contain substring
                data.categories.forEach { (element) in
                    if element.title.contains(inputString){
                        tableViewArray[IndexOf.categories.rawValue].append(CategoriesStructForArray(alias: element.alias, title: element.title))
                    }
                }
                tableView.reloadData()
        }
        urlSessionTask = nil
    }
}
