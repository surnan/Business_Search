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
    func handleLoadBusinesses(temp: YelpInputDataStruct?, result: Result<YelpBusinessResponse, NetworkError>){  //+1
        switch result {
        case .failure(let error):
            if error == NetworkError.needToRetry {
                guard let temp = temp else {return}
                print("handleLoadBusiness --> Retry -> \(error) ... temp = \(temp)")
            } else {
                print("Error that is not 'needToRetry' --> error = \(error)")
            }
        case .success(let data):
            if yelpCategoryArray.isEmpty {
                print("first name = \(data.businesses.first?.name ?? "")")
                addLocationToCoreData(data: data)
            } else {
                print("first name = \(data.businesses.first?.name ?? "")")
                let filterIndex = networkQueueData.firstIndex { (element) -> Bool in
                    guard let temp = temp else {return false}
                    return element.offset == temp.offset
                }
                if let index = filterIndex {
                    networkQueueData.remove(at: index)
                }
                
                buildYelpCategoryArray(data: data)
                let currentLocation = dataController.backGroundContext.object(with: currentLocationID!) as! Location
                currentLocation.addBusinessesAndCategories(yelpData: data, dataController: dataController)
                
                networkQueueData.forEach{
                    print("Success / delete --> outcome --> \($0.offset)")
                }
            }
        }
    }   //-1
    
    func addLocationToCoreData(data: YelpBusinessResponse){ //+1
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
    }   //-1

    
    func getMoreBusinesses(total: Int){ //+1
        while offset <= recordCountAtLocation {
            networkQueueData.append(YelpInputDataStruct(latitude: latitude, longitude: longitude, offset: offset))
            offset += limit
        }
        
        if offset > recordCountAtLocation {
            offset = limit
            downloadAllBusinesses()
        }
    }   //-1
    
    func downloadAllBusinesses(){
        for (_, element) in networkQueueData.enumerated(){
            _ = Yelp.loadUpBusinesses(latitude: latitude, longitude: longitude, offset: element.offset ,completion: handleLoadBusinesses(temp:result:))
        }
    }
}
