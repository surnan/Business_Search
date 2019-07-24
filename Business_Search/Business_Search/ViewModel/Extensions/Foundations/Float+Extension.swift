//
//  Float+Extension.swift
//  Business_Search
//
//  Created by admin on 6/27/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

extension Float {
    func rounded(digits: Int) -> Float {
        let multiplier = pow(10.0, Float(digits))
        return (self * multiplier).rounded() / multiplier
    }
}
