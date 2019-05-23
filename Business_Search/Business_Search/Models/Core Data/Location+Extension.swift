//
//  Business+Extension.swift
//  Business_Search
//
//  Created by admin on 4/20/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData

extension Location {
    //Since context is passed in, Concurrency will be handled by parent function
    func saveBusinessesAndCategories(yelpData: YelpBusinessResponse, context: NSManagedObjectContext){
            yelpData.businesses.forEach { (item) in //+1
                let currentBusiness = Business(context: context)
                currentBusiness.parentLocation = self
                currentBusiness.alias = item.alias
                currentBusiness.displayAddress = item.location.display_address.joined(separator: "?")   //Assuming '?' isn't part of address anywhere on Yelp
                currentBusiness.displayPhone = item.display_phone
                currentBusiness.distance = item.distance!   //EXPLICIT.  Please confirm
                currentBusiness.id = item.id
                currentBusiness.imageURL = item.image_url
                // currentBusiness.isClosed //NEEDS TO BE CALCULATE EVERY CALL?
                currentBusiness.latitude = item.coordinates.latitude ?? 0.0
                currentBusiness.longitude = item.coordinates.longitude ?? 0.0
                currentBusiness.name = item.name
                currentBusiness.price = item.price
                currentBusiness.rating = item.rating ?? 0
                currentBusiness.reviewCount = Int32(item.review_count ?? 0)
                currentBusiness.url = item.url
                
                item.categories.forEach({ (itemCategory) in
                    let currentCategory = Category(context: context)
                    currentCategory.alias = itemCategory.alias
                    currentCategory.title = itemCategory.title
                    currentCategory.business = currentBusiness
                })
        
                do {
                    try context.save()
                } catch {
                    print("Short Error: \(error.localizedDescription)")
                    print("Error saving Business to Location Entity --> func Location.addBusinesses()\n\(error)")
                }
            }
    }
}

