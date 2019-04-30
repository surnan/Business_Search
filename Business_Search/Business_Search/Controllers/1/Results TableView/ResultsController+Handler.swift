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
            print("")
        }
    }
}
