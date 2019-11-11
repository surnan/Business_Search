//
//  CoreData Structs.swift
//  Business Finder
//
//  Created by admin on 8/25/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import CoreData

func createLocation(locationStruct: LocationStruct , context: NSManagedObjectContext)->Bool{
    let item = locationStruct
    let newLocation = Location(context: context)
    newLocation.latitude = item.latitude
    newLocation.longitude = item.longitude
    newLocation.radius = Int32(item.radius)
    newLocation.totalBusinesses = Int32(item.totalBusinesses)
    do {
        try context.save()
        return true
    } catch {
        print("Error 09A: Error saving func addLocation() --\n\(error)")
        print("Localized Error saving func addLocation() --\n\(error.localizedDescription)")
        return false
    }
}


func createFavoriteBusiness(business: Business, context: NSManagedObjectContext){
    let favoriteBusiness = FavoriteBusiness(context: context)
    
    favoriteBusiness.url         = business.url
    favoriteBusiness.reviewCount = business.reviewCount
    favoriteBusiness.rating      = business.rating
    favoriteBusiness.price       = business.price
    favoriteBusiness.name        = business.name
    favoriteBusiness.longitude   = business.longitude
    favoriteBusiness.latitude    = business.latitude
    favoriteBusiness.isPickup    = business.isPickup
    favoriteBusiness.isFavorite  = business.isFavorite
    favoriteBusiness.isDelivery  = business.isDelivery
    favoriteBusiness.imageURL    = business.imageURL
    favoriteBusiness.id          = business.id
    favoriteBusiness.distance    = business.distance
    favoriteBusiness.alias       = business.alias
    favoriteBusiness.displayPhone   = business.displayPhone
    favoriteBusiness.displayAddress = business.displayAddress
    
    business.categories?.forEach({ (currentItem) in
        if let currentCategoryItem = currentItem as? Category {
            let favoriteCategory = FavoriteCategory(context: context)
            favoriteCategory.alias = currentCategoryItem.alias
            favoriteCategory.title = currentCategoryItem.title
            favoriteCategory.favoriteBusiness = favoriteBusiness
        }
        try? context.save()
    })
    
    do {
        try context.save()
    } catch {
        print("Error 14A: Short Error: \(error.localizedDescription)")
        print("Error saving, creating 'createFavoriteBusiness' --> func createFavoriteBusiness()\n\(error)")
    }
    
    
}



func downloadBusinessesAndCategories(id: NSManagedObjectID?, yelpData: YelpBusinessResponse, context: NSManagedObjectContext){
    guard let id = id else {return}
    let parent = context.object(with: id) as! Location
    yelpData.businesses.forEach { (item) in //+1
        let currentBusiness = Business(context: context)
        currentBusiness.parentLocation = parent
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
        
        item.transactions.forEach({ (currentString) in
            if currentString.lowercased().contains("delivery") {
                currentBusiness.isDelivery = true
            }
            
            if currentString.lowercased().contains("pickup") {
                currentBusiness.isPickup = true
            }
        })
        
        do {
            try context.save()
        } catch {
            print("Error 0BA: Short Error: \(error.localizedDescription)")
            print("Error saving Business to Location Entity --> func Location.addBusinesses()\n\(error)")
        }
    }
}




//MARK:- Struct below
struct FavoriteStruct {
    var id: String
}

struct LocationStruct {
    var latitude        : Double    = 250.01
    var longitude       : Double    = 250.01
    var radius          : Int       = -99
    var totalBusinesses : Int       = -11
    var businesses      : [BusinessStruct] = []
}

struct CategoryStruct {
    var alias: String = ""
    var title: String = ""
    var business: Business?
    
    init(alias: String, title: String) {
        self.alias = alias
        self.title = title
    }
}

struct BusinessStruct {
    var alias           : String = ""
    var displayAddress  : String = ""
    var displayPhone    : String = ""
    var distance        : Double = 0.0
    var id              : String = ""
    var imageURL        : String = ""
    var isDelivery      : Bool = false
    var isFavorite      : Bool = false
    var isPickup        : Bool = false
    var latitude        : Double = 0.0
    var longitude       : Double = 0.0
    var name            : String = ""
    var price           : String = ""
    var rating          : Double = 0.0
    var reviewCount     : Int    = 0
    var url             : String = ""
    
    var categories      : [CategoryStruct] = []
    var parentLocation  : LocationStruct?
    
    init(name: String, displayAddress: String, isFavorite: Bool = false) {
        self.name           = name
        self.displayAddress = displayAddress
    }
}
