//
//  Double+Extension.swift
//  Business_Search
//
//  Created by admin on 6/27/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

extension Double {
    func rounded(digits: Int) -> Double {
        let multiplier = pow(10.0, Double(digits))
        return (self * multiplier).rounded() / multiplier
    }
}


