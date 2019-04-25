//
//  Business+Extension.swift
//  Business_Search
//
//  Created by admin on 4/20/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData

//var dataController: DataController!


extension Location {
    func addBusinessesAndCategories(yelpData: YelpBusinessResponse, dataController: DataController){
        
        //  let backgroundContext = dataController.backGroundContext!
        
        
        dataController.backGroundContext.perform {
            yelpData.businesses.forEach { (item) in //+1
                // print(item.name)
                let currentBusiness = Business(context: dataController.backGroundContext)
                currentBusiness.parentLocation = self
                currentBusiness.alias = item.alias
                currentBusiness.displayAddress = item.location.display_address.reduce("", +)
                currentBusiness.displayPhone = item.display_phone
                currentBusiness.distance = item.distance!   //EXPLICIT.  Please confirm
                currentBusiness.id = item.id
                currentBusiness.imageURL = item.image_url
                // currentBusiness.isClosed //NEEDS TO BE CALCULATE EVERY CALL?
                currentBusiness.latitude = item.coordinates.latitude
                currentBusiness.longitude = item.coordinates.longitude
                currentBusiness.name = item.name
                currentBusiness.price = item.price
                currentBusiness.rating = item.rating ?? 0
                currentBusiness.reviewCount = Int32(item.review_count ?? 0)
                currentBusiness.url = item.url
                
                item.categories.forEach({ (itemCategory) in
                    let currentCategory = Category(context: dataController.backGroundContext)
                    currentCategory.alias = itemCategory.alias
                    currentCategory.title = itemCategory.title
                    currentCategory.business = currentBusiness
                })
                
                do {
                    try dataController.backGroundContext.save()
                } catch {
                    print("Error saving Business to Location Entity --> func addBusinesses()\n\(error)")
                }
            } //-1
        }
        
        
        

    }
}
