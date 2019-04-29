//
//  SearchController+Handler.swift
//  Business_Search
//
//  Created by admin on 4/23/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData

//po String(data: data, format: .utf8)
extension SearchController {
    func createLocation(data: YelpBusinessResponse){
        //Save Location Entity and Business Entities for the same API Call
        let backgroundContext = dataController.backGroundContext!
        backgroundContext.perform {
            let newLocation = Location(context: backgroundContext)
            newLocation.latitude = data.region.center.latitude
            newLocation.longitude = data.region.center.longitude
            newLocation.totalBusinesses = Int32(data.total)
            newLocation.radius = Int32(radius)  //AppDelegate
            recordCountAtLocation = data.total
            do {
                try backgroundContext.save()
                self.currentLocationID = newLocation.objectID
                newLocation.saveBusinessesAndCategories(yelpData: data, dataController: self.dataController)  //Because Location is empty
                self.buildURLsQueueForDownloadingBusinesses(total: data.total)    //Because background context, best way to time save happens first
            } catch {
                print("Error saving func addLocation() --\n\(error)")
            }
        }
    }
    
    func handleLoadBusinesses(inputData: YelpGetNearbyBusinessStruct?, result: Result<YelpBusinessResponse, NetworkError>){
        switch result {
        case .failure(let error):
            if error == NetworkError.needToRetry || error == NetworkError.tooManyRequestsPerSecond {
                print("handleLoadBusiness --> Retry -> \(error) ... inputData = \(String(describing: inputData))")
            } else {
                print("Error that is not 'needToRetry' --> error = \(error)")
            }
        case .success(let data):
            if categories.isEmpty {
                createLocation(data: data)
                loadCategoriesAndBusinessesIntoArrays(data: data)
            } else {
                let filterIndex = urlsQueue.firstIndex { (element) -> Bool in
                    guard let inputData = inputData else {return false}
                    return element.offset == inputData.offset
                }
                if let indexToDelete = filterIndex {
                    urlsQueue.remove(at: indexToDelete)
                }
                let currentLocation = dataController.backGroundContext.object(with: currentLocationID!) as! Location
                currentLocation.saveBusinessesAndCategories(yelpData: data, dataController: dataController)
                loadCategoriesAndBusinessesIntoArrays(data: data)
            }
        }
    }
    
    func buildURLsQueueForDownloadingBusinesses(total: Int){
        for index in stride(from: limit, to: recordCountAtLocation, by: limit){
            urlsQueue.append(YelpGetNearbyBusinessStruct(latitude: latitude, longitude: longitude, offset: index))
        }
        downloadAllBusinesses()
    }
    
    func downloadAllBusinesses(){
        if urlsQueue.isEmpty {return}
        let semaphore = DispatchSemaphore(value: 4)
        let dispatchGroup = DispatchGroup()
        
        for (index, element) in urlsQueue.enumerated(){
            dispatchGroup.enter()
            semaphore.wait()
            _ = YelpClient.getNearbyBusinesses(latitude: latitude, longitude: longitude, offset: element.offset ,completion: { [weak self] (yelpDataStruct, result) in
                defer {
                    semaphore.signal()
                    dispatchGroup.leave()
                }
                self?.handleLoadBusinesses(inputData: yelpDataStruct, result: result)
            })
        }
        dispatchGroup.notify(queue: .main) {[weak self] in
            self?.runDownloadAgain()
        }
    }
    
    func runDownloadAgain(){
        print("\nTimer fired!\nurlsQueue ------> \(self.urlsQueue)")
        print("Category Count = \(categories.count)")
        
        var sum = 0
        categories.forEach { (currentArray) in
            sum += currentArray.count
        }
        
        print("Business Count = \(businesses.count)")
        let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { [weak self] timer in
            self?.downloadAllBusinesses()
        }
        timer.fire()
    }
}
