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
            let temp = locationViewModel.createLocation(data: data, context: backgroundContext)
            if let total = temp.total, let id = temp.objectID {
                recordCountAtLocation = total
                currentLocationID = id
                self.verifyLocationBusinessCount(data: data)
                
            }
        }
    }
    
    func verifyLocationBusinessCount(data: YelpBusinessResponse){
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
            showAlertController(title: "ERROR", message: error.toString) {[weak self] _ in
                self?.coordinator?.jumpToMenu()
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
            self.locationViewModel.downloadBusinessesAndCategories(id: self.currentLocationID, yelpData: data, context: self.privateMoc)
            do {
                try self.moc.save()
            } catch {
                print("Error 04A: Error saving parent context 'func queueForSavingBusinesses'")
            }
        }
    }
    
    func buildURLsQueueForDownloadingBusinesses(total: Int){
        let loopMax = min(recordCountAtLocation, yelpMaxPullCount)  //Yelp is limited to 1000 records on pull
        for index in stride(from: limit, to: loopMax, by: limit){
            urlsQueue.append(CreateYelpURLDuringLoopingStruct(latitude: getLatitude, longitude: getLongitude, offset: index))
        }
        downloadYelpBusinesses(latitiude: getLatitude, longitude: getLongitude)
    }
    
    func runDownloadAgain(){
        reloadFetchControllers()
        print("fetchBusiness.FetchedObject.count - ", businessViewModel.getCount,
              "fetchCategoryArray.count - ", categoryCountViewModel.getCount)
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
            //Don't need to store rturned 'URLSessionDataTask?' because .stop/.resume is being utilized
            _ = YelpClient.getBusinesses(latitude: getLatitude, longitude: getLongitude, offset: element.offset ,completion: { [weak self] (yelpDataStruct, result) in
                switch result {
                case .success(let temp):
                    print(temp)
                    defer {dispatchGroup.leave()}
                    self?.handleGetNearbyBusinesses(inputData: yelpDataStruct, result: result)
                case .failure(let error):
                    print("---")
                    fatalError(error.toString)
                }
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
        let allFavorites = favoritesViewModel.fetchedObjects()
        for ( _ , item) in allFavorites.enumerated() {
            businessViewModel.verifyFavoriteStatus(favorite: item)
        }
    }
}
