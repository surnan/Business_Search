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
                self.buildURLsQueueForDownloadingBusinesses(total: data.total)    //Because background context, best way to time save happens first
                fetchBusinessController = nil
                fetchCategoriesController = nil
                tableView.reloadData()
            } catch {
                print("Error saving func addLocation() --\n\(error)")
            }
        }
    }
    
    func queueForSavingBusinesses(_ data: (YelpBusinessResponse)) {
        myQueue.addOperation {
            self.dataController.persistentContainer.performBackgroundTask {[unowned self] (context) in
                //Giving Core Data the chance to perform multiple instances in parallel
                let currentLocation = context.object(with: self.currentLocationID!) as! Location
                currentLocation.saveBusinessesAndCategories(yelpData: data, context: context)
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
                doesLocationEntityExist = true
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
    
    

    
    
    func buildURLsQueueForDownloadingBusinesses(total: Int){
        for index in stride(from: limit, to: recordCountAtLocation, by: limit){
            let coord = possibleInsertLocationCoordinate.coordinate
            urlsQueue.append(CreateYelpURLDuringLoopingStruct(latitude: coord.latitude, longitude: coord.longitude, offset: index))
        }
        downloadYelpBusinesses()
    }

    
    func downloadYelpBusinesses(latitiude: Double, longitude: Double){
        if urlsQueue.isEmpty {return}
        let semaphore = DispatchSemaphore(value: 4)
        let dispatchGroup = DispatchGroup()
        
        for (index, element) in urlsQueue.enumerated(){
            dispatchGroup.enter()
            semaphore.wait()
            _ = YelpClient.getBusinesses(latitude: latitude, longitude: longitude, offset: element.offset ,completion: { [weak self] (yelpDataStruct, result) in
                defer {
                    semaphore.signal()
                    dispatchGroup.leave()
                }
                self?.handleGetNearbyBusinesses(inputData: yelpDataStruct, result: result)
            })
        }
        dispatchGroup.notify(queue: .main) {[weak self] in
            self?.runDownloadAgain()
        }
    }
    
    
    func downloadYelpBusinesses(){
        if urlsQueue.isEmpty {return}
        let semaphore = DispatchSemaphore(value: 4)
        let dispatchGroup = DispatchGroup()
        
        for (index, element) in urlsQueue.enumerated(){
            dispatchGroup.enter()
            semaphore.wait()
            _ = YelpClient.getBusinesses(latitude: latitude, longitude: longitude, offset: element.offset ,completion: { [weak self] (yelpDataStruct, result) in
                defer {
                    semaphore.signal()
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
        print("\nTimer fired!\nurlsQueue ------> \(self.urlsQueue)")
        self.fetchBusinessController = nil
        self.fetchCategoriesController = nil
        tableView.reloadData()
        print("fetchBusiness.FetchedObject.count - ", fetchBusinessController?.fetchedObjects?.count ?? -999)
        print("fetchCategoryArray.count - ", fetchCategoryNames?.count ?? -999)
        let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { [weak self] timer in
            self?.downloadYelpBusinesses()
        }
        timer.fire()
    }
}
