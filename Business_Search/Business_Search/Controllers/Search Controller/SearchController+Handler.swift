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
    
    func handleLoadUpBusinesses(result: Result<YelpBusinessResponse, NetworkError>){ //+1
        switch result { //+2
        case .failure(let error):
            print("-->Error (localized): \(error.localizedDescription)\n-->Error (Full): \(error)")
        case .success(let data):
            // print("Number of Records returned = \(data.businesses.count)")
            print("Total = \(data.total)")
            print("first name = \(data.businesses.first?.name ?? "")")
            addLocationToCoreData(data: data)
        } //-2
    } //-1
    
    func addLocationToCoreData(data: YelpBusinessResponse){
        let backgroundContext = dataController.backGroundContext!
        let newLocation = Location(context: backgroundContext)
        newLocation.latitude = data.region.center.latitude
        newLocation.longititude = data.region.center.longitude
        newLocation.totalBusinesses = Int32(data.total)
        newLocation.radius = Int32(radius)  //AppDelegate
        buildYelpCategoryArray(data: data)  //Array built but data not saved
        do {
            try backgroundContext.save()
            currentLocationID = newLocation.objectID
            newLocation.addBusinesses(yelpData: data, dataController: dataController)  //Because Location is empty
            continueCallingBusinesses()
        } catch {
            print("Error saving func addLocation() --\n\(error)")
        }
    }
    
    func continueCallingBusinesses(){
        _ = Yelp.loadUpBusinesses(latitude: latitude, longitude: longitude, offset: 50 ,completion: handleSamePin(result:))
        _ = Yelp.loadUpBusinesses(latitude: latitude, longitude: longitude, offset: 100 ,completion: handleSamePin(result:))
        _ = Yelp.loadUpBusinesses(latitude: latitude, longitude: longitude, offset: 150 ,completion: handleSamePin(result:))
    }
    
    
    
    func handleSamePin(result: Result<YelpBusinessResponse, NetworkError>){
        switch result {
        case .failure(let error):
            print("handleSamePin() failed --> \(error.localizedDescription)")
        case .success(let data):
            print("first name = \(data.businesses.first?.name ?? "")")
            buildYelpCategoryArray(data: data)
            let currentLocation = dataController.backGroundContext.object(with: currentLocationID!) as! Location
            currentLocation.addBusinesses(yelpData: data, dataController: dataController)
//            print("--------")
//            yelpCategoryArray.forEach{print($0.first?.title)}
//            print("")
        }
    }
    
    
    //MARK:- Below is Bar Button functions or Called in ViewDidLoad()
    @objc func handleDeleteAll(){
        do {
            let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Location")
            let request = NSBatchDeleteRequest(fetchRequest: fetch)
            try self.dataController.backGroundContext.execute(request)
            try self.dataController.backGroundContext.save()
        } catch {
            print ("There was an error deleting Locations from CoreData")
        }
    }
    
    @objc func handleGetNewLocation(){
        _ = Yelp.loadUpBusinesses(latitude: latitude, longitude: longitude, completion: handleLoadUpBusinesses(result:))
    }
}
