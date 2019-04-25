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
            do {
                try backgroundContext.save()
                self.buildYelpCategoryArray(data: data)  //Array built but data not saved
                self.currentLocationID = newLocation.objectID
                newLocation.addBusinessesAndCategories(yelpData: data, dataController: self.dataController)  //Because Location is empty
                self.continueCallingBusinesses(total: data.total)
            } catch {
                print("Error saving func addLocation() --\n\(error)")
            }
        }
    }
    
    //po String(data: data, format: .utf8)
    //networkQueueData
    func handleLoadBusinesses(temp: YelpInputDataStruct?, result: Result<YelpBusinessResponse, NetworkError>){
        switch result {
        case .failure(let error):
            if error == NetworkError.needToRetry {
                print("handleLoadBusiness --> Retry.  temp = \(String(describing: temp))")
                guard let temp = temp else {return}
                networkQueueData.append(temp)
                print("")
            } else {
                print("Error that is not 'needToRetry' --> error = \(error)")
            }
        case .success(let data):
            if yelpCategoryArray.isEmpty {
                print("\nfirst name = \(data.businesses.first?.name ?? "")")
                addLocationToCoreData(data: data)
            } else {
                print("\nfirst name = \(data.businesses.first?.name ?? "")")
                buildYelpCategoryArray(data: data)
                let currentLocation = dataController.backGroundContext.object(with: currentLocationID!) as! Location
                currentLocation.addBusinessesAndCategories(yelpData: data, dataController: dataController)
            }
        }
    }
    
    func continueCallingBusinesses(total: Int){
        while offset <= total {
            _ = Yelp.loadUpBusinesses(latitude: latitude, longitude: longitude, offset: offset ,completion: self.handleLoadBusinesses(temp:result:))
            offset += limit
        }
        
        if offset > total {
            offset = limit
        }
    }
}
