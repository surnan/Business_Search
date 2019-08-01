//
//  OpenController+Handlers.swift
//  Business_Search
//
//  Created by admin on 7/31/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

extension OpenController {
    //MARK:- BreakPoint
        @objc func handleSettings(){
            addDarkScreenBlur()
            coordinator?.loadSettings(delegate: self, max: radius)
        }
    
        @objc func handleFilter(){
            addDarkScreenBlur()
            coordinator?.loadFilter(unblurProtocol: self)
        }
    
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
            recordCountAtLocation = data.total  //Number of businesses @ this location with current radius
            do {
                try backgroundContext.save()    //Saves only Location-entity.  @ this stage business/categories = zero
                self.currentLocationID = newLocation.objectID
                self.checkLocationCount(data: data)
            } catch {
                print("Error saving func addLocation() --\n\(error)")
            }
        }
    }
    
    func checkLocationCount(data: YelpBusinessResponse){
        if recordCountAtLocation > yelpMaxPullCount {
            navigationController?.setNavigationBarHidden(true, animated: true)
            let myAlertController = UIAlertController(title: "Not All Businesses Downloaded",
                                                      message: "More than \(yelpMaxPullCount) businesses found.  Reducing search radius can bring more accurate results", preferredStyle: .alert)
            myAlertController.addAction(UIAlertAction(title: "Change Radius", style: .default, handler: { _ in
                self.handleSettings()
            }))
            myAlertController.addAction(UIAlertAction(title: "Continue", style: .default, handler: {_ in
                self.queueForSavingBusinesses(data)
                self.buildURLsQueueForDownloadingBusinesses(total: data.total)
                self.reloadFetchControllers()
            }))
            present(myAlertController, animated: true)
        } else {
            queueForSavingBusinesses(data)
            buildURLsQueueForDownloadingBusinesses(total: data.total)
            reloadFetchControllers()
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
            urlsQueue.append(CreateYelpURLDuringLoopingStruct(latitude: getLatitude, longitude: getLongitude, offset: index))
        }
        downloadYelpBusinesses(latitiude: getLatitude, longitude: getLongitude)
    }
    
    func runDownloadAgain(){
        reloadFetchControllers()
        print("fetchBusiness.FetchedObject.count - ", businessViewModel.fetchBusinessController?.fetchedObjects?.count ?? -999, "fetchCategoryArray.count - ", categoryCountViewModel.fetchCategoryNames?.count ?? -999)
        let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { [unowned self] timer in
            self.downloadYelpBusinesses(latitiude: self.getLatitude, longitude: self.getLongitude)
        }
        timer.fire()
    }
    
    func downloadYelpBusinesses(latitiude: Double, longitude: Double){
        if urlsQueue.isEmpty {return}
        let semaphore = DispatchSemaphore(value: 4)
        let dispatchGroup = DispatchGroup()
        for (index, element) in urlsQueue.enumerated(){
            if index > 3 {break}
            dispatchGroup.enter()
            _ = YelpClient.getBusinesses(latitude: getLatitude, longitude: getLongitude, offset: element.offset ,completion: { [weak self] (yelpDataStruct, result) in
                defer {dispatchGroup.leave()}
                self?.handleGetNearbyBusinesses(inputData: yelpDataStruct, result: result)
            })
        }
        dispatchGroup.notify(queue: .main) {[weak self] in
            guard let self = self else {return}
            self.runDownloadAgain()
            if self.urlsQueue.isEmpty {
                //Last download was executed but no guarantee data for it was saved
                self.searchFavorites()
                print("!!Completed all the downloads when record count > 50!!")
            }
        }
    }
    
    func searchFavorites(){
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        
        let block1 = BlockOperation {
            self.searchFavoritesIterations()
        }
        
        let block2 = BlockOperation  {
            self.resetAllFetchControllers()
        }
        
        block2.addDependency(block1)
        queue.addOperations([block1, block2], waitUntilFinished: false)
        
    }
    
    func searchFavoritesIterations(){
        resetAllFetchControllers()
        
        //let allFavorites = tableDataSource.fetchFavoritesController?.fetchedObjects ?? []
        let allFavorites = favoritesViewModel.fetchFavoritesController?.fetchedObjects ?? []
        
        
        for ( _ , item) in allFavorites.enumerated() {
            guard let id = item.id else {return}
            
            
            //tableDataSource.updateBusinessPredicate(id: id)
            businessViewModel.search(id: id)
            
            
            //let results = tableDataSource.fetchBusinessController?.fetchedObjects ?? []
            let results = businessViewModel.fetchBusinessController?.fetchedObjects ?? []
            
            
            if results.isEmpty {
                return
            } else {
                results.first?.isFavorite = true
                do {
                    try dataController.viewContext.save()
                    resetAllFetchControllers()
                } catch {
                    print("Error saving favorite after finding match - \(error)")
                }
            }
        }
    }
}
