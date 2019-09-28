//
//  SearchByAddressController+TextDelegate.swift
//  Business_Search
//
//  Created by admin on 9/25/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit


extension SearchByAddressController {
    @objc func textFieldDidChange(_ textField: UITextField) {
            setRightBarButton(state: .disabled)
    }
}


