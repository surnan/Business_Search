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
    

    
    func addLocationToCoreData(data: YelpBusinessResponse){
        let backgroundContext = dataController.backGroundContext!
        backgroundContext.perform {
            let newLocation = Location(context: backgroundContext)
            newLocation.latitude = data.region.center.latitude
            newLocation.longititude = data.region.center.longitude
            newLocation.totalBusinesses = Int32(data.total)
            newLocation.radius = Int32(radius)  //AppDelegate
            self.buildYelpCategoryArray(data: data)  //Array built but data not saved
            do {
                try backgroundContext.save()
                self.currentLocationID = newLocation.objectID
                newLocation.addBusinesses(yelpData: data, dataController: self.dataController)  //Because Location is empty
                self.continueCallingBusinesses(total: data.total)
            } catch {
                print("Error saving func addLocation() --\n\(error)")
            }
        }
    }
    
    func continueCallingBusinesses(total: Int){
        print("limit = \(limit) .... offset = \(offset) ..... total = \(total)")
        let extraIteration = total % limit == 0 ? 0 : 1
        let indexMax = (total / limit + extraIteration) - 1 // -1 because first loop already run

        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        
        
        
        for index in 1...indexMax {
            let currentOffset = offset * index
            queue.addOperation {

                _ = Yelp.loadUpBusinesses(latitude: latitude, longitude: longitude, offset: currentOffset ,completion: self.handleSamePin(result:))
            }
        }
        
        queue.waitUntilAllOperationsAreFinished()
    
    }
    
    func handleSamePin(result: Result<YelpBusinessResponse, NetworkError>){
        print("hi = \(hi)")
        hi += 1
        switch result {
        case .failure(let error):
            print("handleSamePin() failed --> \(error.localizedDescription)")
        case .success(let data):
            print("\nfirst name = \(data.businesses.first?.name ?? "")")
            buildYelpCategoryArray(data: data)
            let currentLocation = dataController.backGroundContext.object(with: currentLocationID!) as! Location
            currentLocation.addBusinesses(yelpData: data, dataController: dataController)
            //            print("--------")
            //            yelpCategoryArray.forEach{print($0.first?.title)}
            //            print("")
        }
    }
    
    func handleLoadUpBusinesses(result: Result<YelpBusinessResponse, NetworkError>){ //+1
        switch result { //+2
        case .failure(let error):
            print("-->Error (localized): \(error.localizedDescription)\n-->Error (Full): \(error)")
        case .success(let data):
            // print("Number of Records returned = \(data.businesses.count)")
            print("Total = \(data.total)")
            print("\nfirst name = \(data.businesses.first?.name ?? "")")
            addLocationToCoreData(data: data)
        } //-2
    } //-1
    

}
