//
//  SearchController+Handler.swift
//  Business_Search
//
//  Created by admin on 4/23/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData

extension SearchController {
    
    //po String(data: data, format: .utf8)
    func handleLoadBusinesses(temp: YelpInputDataStruct?, result: Result<YelpBusinessResponse, NetworkError>){
        switch result {
        case .failure(let error):
            if error == NetworkError.needToRetry {
                guard let temp = temp else {return}
                print("handleLoadBusiness --> Retry -> \(error) ... temp = \(temp)")
            } else {
                print("Error that is not 'needToRetry' --> error = \(error)")
                //networkQueueData.append(temp) //DELETE FROM 'networkQueue'
            }
        case .success(let data):
            if yelpCategoryArray.isEmpty {
                print("first name = \(data.businesses.first?.name ?? "")")
                addLocationToCoreData(data: data)
            } else {
                print("first name = \(data.businesses.first?.name ?? "")")
                buildYelpCategoryArray(data: data)
                let currentLocation = dataController.backGroundContext.object(with: currentLocationID!) as! Location
                currentLocation.addBusinessesAndCategories(yelpData: data, dataController: dataController)
            }
        }
    }
    
    func addLocationToCoreData(data: YelpBusinessResponse){
        //Save Location Entity and Business Entities for the same API Call
        let backgroundContext = dataController.backGroundContext!
        
        backgroundContext.perform { //+2
            let newLocation = Location(context: backgroundContext)
            newLocation.latitude = data.region.center.latitude
            newLocation.longititude = data.region.center.longitude
            newLocation.totalBusinesses = Int32(data.total)
            newLocation.radius = Int32(radius)  //AppDelegate
            recordCountAtLocation = data.total
            do {    //+3
                try backgroundContext.save()
                self.buildYelpCategoryArray(data: data)  //Array but Saved = Location & No Businesses
                self.currentLocationID = newLocation.objectID
                newLocation.addBusinessesAndCategories(yelpData: data, dataController: self.dataController)  //Because Location is empty
                self.getMoreBusinesses(total: data.total)    //Because background context, best way to time save happens first
            } catch {
                print("Error saving func addLocation() --\n\(error)")
            }   //-3
        }   //-2
        
        
        
    }

    
    func getMoreBusinesses(total: Int){ //+1
        while offset <= recordCountAtLocation {
                print("INSIDE ==> Total = \(total) .... Offset = \(offset)")
            networkQueueData.append(YelpInputDataStruct(latitude: latitude, longitude: longitude, offset: offset))
            offset += limit
        }
        
        if offset > recordCountAtLocation {
            print("OUTSIDE ==> Total = \(total) .... Offset = \(offset)")
            offset = limit
        }
    }   //-1
}


//_ = Yelp.loadUpBusinesses(latitude: latitude, longitude: longitude, offset: offset ,completion: self.handleLoadBusinesses(temp:result:))
//networkQueueData
