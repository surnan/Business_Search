//
//  TESTING.swift
//  Business_Search
//
//  Created by admin on 4/29/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

extension Array where Element == [Category] {
    
    func indexOfFirstItemMatching(category: Category)-> Int? {
        if self.isEmpty {
            return nil
        }

        guard let inputString = category.title else {return nil}
        for index in 0 ..< self.count {
            if let firstElementInCategoryArray = self[index].first {
                if firstElementInCategoryArray.title == inputString {
                    return index
                }
            }
        }
        return nil
    }
}
