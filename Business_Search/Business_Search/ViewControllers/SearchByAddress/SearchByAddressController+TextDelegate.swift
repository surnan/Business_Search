//
//  SearchByAddressController+TextDelegate.swift
//  Business_Search
//
//  Created by admin on 9/25/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

extension SearchByAddressController {
    
    //MARK:- TextField Delegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        view.endEditing(true)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }

}
