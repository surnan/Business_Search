//
//  OpeningController+Handler.swift
//  Business_Search
//
//  Created by admin on 5/9/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData
import MapKit

extension OpeningController {
    func createLocation(data: YelpBusinessResponse){
        //Save Location Entity and Business Entities for the same API Call
        let backgroundContext = dataController.backGroundContext!
        backgroundContext.performAndWait {
            //Synchronous to make sure //1 occurs before //2
            let newLocation = Location(context: backgroundContext)
            newLocation.latitude = data.region.center.latitude
            newLocation.longitude = data.region.center.longitude
            newLocation.totalBusinesses = Int32(data.total)
            newLocation.radius = Int32(radius)  //AppDelegate
            recordCountAtLocation = data.total
            do {
                try backgroundContext.save()    //1
                self.currentLocationID = newLocation.objectID
                queueForSavingBusinesses(data)
                self.buildURLsQueueForDownloadingBusinesses(total: data.total)
                reloadFetchControllers()
            } catch {
                print("Error saving func addLocation() --\n\(error)")
            }
        }
    }
    
    func handleGetNearbyBusinesses(inputData: CreateYelpURLDuringLoopingStruct?, result: Result<YelpBusinessResponse, NetworkError>){
        switch result {
        case .failure(let error):
            if error == NetworkError.needToRetry || error == NetworkError.tooManyRequestsPerSecond {
                print("handleLoadBusiness --> Retry -> \(error))")
            } else {
                print("Error that is not 'needToRetry' --> error = \(error)")
            }
        case .success(let data):
            if !doesLocationEntityExist {
                createLocation(data: data)
                doesLocationEntityExist = true  //Create Location will be run maximum once
            } else {
                let filterIndex = urlsQueue.firstIndex { (element) -> Bool in
                    guard let inputData = inputData else {return false}
                    return element.offset == inputData.offset
                }
                if let indexToDelete = filterIndex {
                    urlsQueue.remove(at: indexToDelete)
                }
                queueForSavingBusinesses(data)
            }
        }
    }
    
    func queueForSavingBusinesses(_ data: (YelpBusinessResponse)) {
        privateMoc.performAndWait {[weak self] in
            guard let self = self else {return}
            let currentLocation = self.privateMoc.object(with: self.currentLocationID!) as! Location
            currentLocation.saveBusinessesAndCategories(yelpData: data, context: self.privateMoc)
            do {
                try self.moc.save()
            } catch {
                print("Error saving parent context 'func queueForSavingBusinesses'")
            }
        }
    }

    
    
    func buildURLsQueueForDownloadingBusinesses(total: Int){
    //let yelpMaxPullCount = 1000
        let loopMax = min(recordCountAtLocation, yelpMaxPullCount)  //Yelp is limited to 1000 records on pull
        
        for index in stride(from: limit, to: loopMax, by: limit){
            urlsQueue.append(CreateYelpURLDuringLoopingStruct(latitude: latitude, longitude: longitude, offset: index))
        }
        downloadYelpBusinesses(latitiude: latitude, longitude: longitude)
    }
    
    func downloadYelpBusinesses(latitiude: Double, longitude: Double){
        if urlsQueue.isEmpty {return}
        let semaphore = DispatchSemaphore(value: 4)
        let dispatchGroup = DispatchGroup()
        
        print("urlsQueue.count = \(urlsQueue.count)")
        for (index, element) in urlsQueue.enumerated(){
            if index > 3 {break}
            dispatchGroup.enter()
            _ = YelpClient.getBusinesses(latitude: latitude, longitude: longitude, offset: element.offset ,completion: { [weak self] (yelpDataStruct, result) in
                defer {
                    dispatchGroup.leave()
                }
                self?.handleGetNearbyBusinesses(inputData: yelpDataStruct, result: result)
            })
        }
        dispatchGroup.notify(queue: .main) {[weak self] in
            self?.runDownloadAgain()
        }
    }
    
    func runDownloadAgain(){
        reloadFetchControllers()
        print("\nTimer fired!\nurlsQueue ------> \(self.urlsQueue)")
        print("fetchBusiness.FetchedObject.count - ", fetchBusinessController?.fetchedObjects?.count ?? -999)
        print("fetchCategoryArray.count - ", fetchCategoryNames?.count ?? -999)
        let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { [weak self] timer in
            self?.downloadYelpBusinesses(latitiude: self!.latitude, longitude: self!.longitude)
        }
        timer.fire()
    }
}
