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
            print("---> Succesfully decoded data")
            print("Number of Records returned = \(data.businesses.count)")
            print("Total = \(data.total)")
            addLocation(data: data)
        } //-2
    } //-1
    
    func addLocation(data: YelpBusinessResponse){
        let backgroundContext = dataController.backGroundContext!
        let newLocation = Location(context: backgroundContext)
        newLocation.latitude = data.region.center.latitude
        newLocation.longititude = data.region.center.longitude
        newLocation.totalBusinesses = Int32(data.total)
        newLocation.radius = Int32(radius) //AppDelegate
        buildYelpCategoryArray(data: data)
        do {
            try backgroundContext.save()
            newLocation.addBusinesses(yelpData: data, dataController: dataController)
        } catch {
            print("Error saving func addLocation() --\n\(error)")
        }
    }
    
    
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
        getNewLocationData()
    }
    

}
