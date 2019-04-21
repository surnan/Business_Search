//
//  Business+Extension.swift
//  Business_Search
//
//  Created by admin on 4/20/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

//var dataController: DataController!

extension Business {
    func fromJSON(yelpData: YelpBusinessResponse, dataController: DataController){
        yelpData.businesses.forEach { (current) in
            self.alias = current.alias ?? ""
            self.displayAddress = current.location.display_address.first ?? ""
            self.displayPhone = current.display_phone ?? ""
            self.distance = current.distance ?? 0
            self.id = current.id ?? ""
            self.imageURL = current.image_url ?? ""
            self.isClosed = current.is_closed ?? false
            self.latitude = current.coordinates.latitude ?? 0
            self.longitude = current.coordinates.longitude ?? 0
            self.name = current.name ?? ""
            self.price = current.price ?? ""
            self.rating = current.rating ?? 0
            self.reviewCount = Int32(current.review_count ?? 0)
            self.url = current.url ?? ""
            
            current.categories.forEach({ (categoryStruct) in
                let newCategory = Category(context: dataController.viewContext)
                newCategory.title = categoryStruct.title
                newCategory.alias = categoryStruct.alias
//                newCategory.business = newCategory
            })
            
            current.categories.forEach({ (categoryStruct) in
                let newCategory = Category(context: dataController.viewContext)
                newCategory.title = categoryStruct.title
                newCategory.alias = categoryStruct.alias
                //                newCategory.business = newCategory
            })
            
        }
    }
}


extension Category {
    func add(business: Business){
        
    }
}
