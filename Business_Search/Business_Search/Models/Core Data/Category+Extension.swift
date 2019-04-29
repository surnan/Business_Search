//
//  Category+Extension.swift
//  Business_Search
//
//  Created by admin on 4/29/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import CoreData

extension Category {
    func matches (rhs: Category)-> Bool{
        if  rhs.title == self.title {
            categoryMatch += 1
        }
        
        return rhs.title == self.title
    }
}
