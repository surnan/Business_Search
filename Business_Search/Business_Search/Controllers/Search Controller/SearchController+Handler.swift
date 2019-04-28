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
    //NEED THE ERROR CASE FOR TOO MANY REQUESTS IN ONE SECOND
    
    func handleLoadBusinesses(inputData: YelpInputDataStruct?, result: Result<YelpBusinessResponse, NetworkError>){  //+1
        
        switch result {
        case .failure(let error):
            if error == NetworkError.needToRetry || error == NetworkError.tooManyRequestsPerSecond {
                print("handleLoadBusiness --> Retry -> \(error) ... inputData = \(String(describing: inputData))")
            } else {
                print("Error that is not 'needToRetry' --> error = \(error)")
            }
        case .success(let data):
            if yelpCategoryArray.isEmpty {
                print("first name = \(data.businesses.first?.name ?? "")")
                addLocationToCoreData(data: data)
            } else {
                let filterIndex = urlsQueue.firstIndex { (element) -> Bool in
                    guard let inputData = inputData else {return false}
                    return element.offset == inputData.offset
                }
                
                print("\nSUCCESS-ELSE-BEFORE-REMOVE")
                if let index = filterIndex {
                    print("Index to delete = \(index)")
                    urlsQueue.forEach{
                        print("off --> \($0.offset)", terminator: " .. ")
                    }
                    
                    urlsQueue.remove(at: index)
                    
                    print("\nSUCCESS-ELSE-AFTER-REMOVE")
                    urlsQueue.forEach{
                        print("OFF --> \($0.offset)", terminator: " ++ ")
                    }
                }
                buildYelpCategoryArray(data: data)
                let currentLocation = dataController.backGroundContext.object(with: currentLocationID!) as! Location
                currentLocation.addBusinessesAndCategories(yelpData: data, dataController: dataController)
            }
        }
        
        print("\n")
        urlsQueue.forEach{
            print("END-> \($0.offset)", terminator: " == ")
        }
    }   //-1
    
    
    func runDownloadAgain(){
        print("urlsQueue ------> \(self.urlsQueue)")
        let timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { timer in
            print("Timer fired!")
            self.downloadAllBusinesses()
        }
        timer.fire()
    }
    
    
    
    
    //func downloadAllBusinesses(){
    //    if urlsQueue.isEmpty {return}
    //
    //
    //    //        let dispatchGroup = DispatchGroup()
    //    let semaphore = DispatchSemaphore(value: 2)
    //
    //    for (index, element) in urlsQueue.enumerated(){
    //        //            dispatchGroup.enter()
    //        semaphore.wait()
    //        _ = Yelp.loadUpBusinesses(latitude: latitude, longitude: longitude, offset: element.offset ,completion: { (yelpDataStruct, result) in
    //            defer {
    //                semaphore.signal()
    //                //                    dispatchGroup.leave()
    //            }
    //            self.handleLoadBusinesses(inputData: yelpDataStruct, result: result)
    //        })
    //    }
    //
    //    //        dispatchGroup.notify(queue: .main, execute: runDownloadAgain)
    //
    //}
    
    func downloadAllBusinesses(){
        if urlsQueue.isEmpty {return}
        let semaphore = DispatchSemaphore(value: 5)
        let dispatchGroup = DispatchGroup()
        
        for (index, element) in urlsQueue.enumerated(){
            dispatchGroup.enter()
            semaphore.wait()
            _ = APIclient.loadUpBusinesses(latitude: latitude, longitude: longitude, offset: element.offset ,completion: { (yelpDataStruct, result) in
                defer {
                    semaphore.signal()
                    dispatchGroup.leave()
                }
                self.handleLoadBusinesses(inputData: yelpDataStruct, result: result)
            })
        }
        
        dispatchGroup.notify(queue: .main) {[weak self] in
            print("Inside NOTIFY")
            print("urlsQueue = \(String(describing: self?.urlsQueue))")
            self?.runDownloadAgain()
        }
    }
    
    
    
    func getMoreBusinesses(total: Int){ //+1
        for index in stride(from: limit, to: recordCountAtLocation, by: limit){
            urlsQueue.append(YelpInputDataStruct(latitude: latitude, longitude: longitude, offset: index))
        }
        downloadAllBusinesses()
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
    
    
    
}





/*
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
 */

/*
 dispatchGroup.notify(queue: .main) {[weak self] in
 print("\n\nCompleted all the looping")
 print("NetworkQueData.count =  \(self?.networkQueueData.count ?? -111)")
 
 self?.networkQueueData.forEach{
 print($0.offset, terminator: "...")
 }
 
 if self?.networkQueueData.count != 0 {
 self?.runDownloadAgain()
 }
 print("\n")
 }
 
 */
