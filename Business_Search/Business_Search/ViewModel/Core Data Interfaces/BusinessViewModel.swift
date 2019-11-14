//
//  OpenViewModel.swift
//  Business_Search
//
//  Created by admin on 7/29/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import CoreData
import MapKit

class BusinessViewModel {
    private var delegate: OpenControllerType!
    private var dataController: DataController
    private var gpsLocation: CLLocation!

    private var predicateBusinessLatitude: NSPredicate {
        return NSPredicate(format: "%K == %@", argumentArray: [#keyPath(Business.parentLocation.latitude), delegate.getLatitude])
    }
    
    private var predicateBusinessLongitude: NSPredicate {
      return NSPredicate(format: "%K == %@", argumentArray: [#keyPath(Business.parentLocation.longitude), delegate.getLongitude])
    }
    
    private var fetchBusinessPredicate : NSPredicate? {
        didSet {
            NSFetchedResultsController<NSFetchRequestResult>.deleteCache(withName: nil) //Just in case
            fetchBusinessController?.fetchRequest.predicate = fetchBusinessPredicate
        }
    }
    
    private var businessSortDescriptor: [NSSortDescriptor] {
        return UserAppliedFilter.shared.getBusinessSortDescriptor()
    }
    
    private var fetchBusinessController: NSFetchedResultsController<Business>? { //+1
        didSet {    //+2
            if fetchBusinessController == nil { //+3
                fetchBusinessController = {   //+4
                    let fetchRequest: NSFetchRequest<Business> = Business.fetchRequest()
                    var predicate: [NSPredicate] = [predicateBusinessLatitude, predicateBusinessLongitude]
                    if let _predicate = fetchBusinessPredicate { predicate.append(_predicate)}
                    let openingControllerPredicate =  NSCompoundPredicate(andPredicateWithSubpredicates: predicate)
                    var filterControllerPredicate = UserAppliedFilter.shared.getBusinessPredicate()
                    filterControllerPredicate.append(openingControllerPredicate)
                    
                    fetchRequest.predicate = NSCompoundPredicate(type: .and, subpredicates: filterControllerPredicate)
                    fetchRequest.sortDescriptors = businessSortDescriptor
                    
                    
                    
                    
                    let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                               managedObjectContext: dataController.viewContext,
                                                                               sectionNameKeyPath: nil,
                                                                               cacheName: nil)
                    do {
                        try aFetchedResultsController.performFetch()
                    } catch let error {
                        fatalError("Error 06A: Unresolved error \(error)")
                    }
                    return aFetchedResultsController
                }() //-4
            }   //-3
        }   //-2
    }   //-1
    
    
    //MARK:- NON-Private
    init(delegate: OpenControllerType, dataController: DataController, gpsLocation: CLLocation? = nil) {
        self.dataController = dataController
        self.delegate = delegate
        if let gpsLocation = gpsLocation {
            self.gpsLocation = gpsLocation
            calculateNewDistances(gpsLocation: gpsLocation)
        }
    }

    init(dataController: DataController, gpsLocation: CLLocation? = nil) {
        //Used in BusinessDetails
        self.dataController = dataController
        
        
        if let gpsLocation = gpsLocation {
            self.gpsLocation = gpsLocation
            calculateNewDistances(gpsLocation: gpsLocation)
        }
    }
    
    
    func calculateNewDistances(gpsLocation: CLLocation){
        self.gpsLocation = gpsLocation

        let allBusinesses = fetchedObjects()
        
        for item in allBusinesses {
            let businessLocation = CLLocation(latitude: item.latitude, longitude: item.longitude)
            let newDistance = gpsLocation.distance(from: businessLocation)
            item.newDistance = newDistance
        }
        
        
        do {
            try dataController.viewContext.save()
            reload()
        } catch {
            print("Error 16A: Unable to save updates to Business.NewDistance")
            print(error)
            print(error.localizedDescription)
        }
        
        
        
        
    }
    
    var getCount: Int {return fetchBusinessController?.fetchedObjects?.count ?? 0}
    var isEmpty: Bool {return fetchBusinessController?.fetchedObjects?.count == 0}
    func reload() {fetchBusinessController = nil}
    func fetchedObjects() -> [Business]{fetchBusinessController = nil; return fetchBusinessController!.fetchedObjects ?? []}
    func objectAt(indexPath: IndexPath)-> Business? {return fetchBusinessController?.object(at: indexPath)} //It's OK for forced-unwrap because it has to exist at this stage   //Sometimes objectAt returns NIL

    func verifyFavoriteStatus(favorite: Favorites){
        guard let id = favorite.id else {return}
        fetchBusinessPredicate = NSPredicate(format: "id CONTAINS[cd] %@", argumentArray: [id])
        reload()
        let results = fetchedObjects()
        if !results.isEmpty {
            results.first?.isFavorite = true
            do {
                try dataController.viewContext.save()
            } catch {
                print("Error 07A: Error saving favorite after finding match - \(error.localizedDescription)\n\(error)")
            }
        }
    }
    
    func search(search: String?){
        if let search = search {
            fetchBusinessPredicate  = NSPredicate(format: "name CONTAINS[cd] %@", argumentArray: [search])
            reload()
        } else {
            fetchBusinessPredicate  = nil
            reload()
        }
    }
    
    func search(id: String){
        fetchBusinessPredicate = NSPredicate(format: "id CONTAINS[cd] %@", argumentArray: [id])
        reload()
    }
    
    
    func search(business: Business){
        let nameToFind = business.name ?? ""
        fetchBusinessPredicate = NSPredicate(format: "name MATCHES %@", argumentArray: [nameToFind])
        reload()
    }
    
    
    private func isFavorite(at indexPath: IndexPath)->Bool{
        let currentBusiness = fetchBusinessController?.object(at: indexPath)
        return currentBusiness?.isFavorite ?? false
    }
    
    func changeFavorite(business: Business)->Bool?{
        let objectID = business.objectID
        
        let currentBusiness = dataController.viewContext.object(with: objectID) as! Business
        currentBusiness.isFavorite = !currentBusiness.isFavorite
        
        do {
            try dataController.viewContext.save()
            return currentBusiness.isFavorite
        } catch {
            print("Error 9Z11: Error changing Business Favorite Flag")
            return nil
        }
    }
    
    func removeAllFavorites(){
        let tempFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Business")
        var temp = [Business]()
        
        do {
            temp = try dataController.viewContext.fetch(tempFetch) as! [Business]
        } catch {
            print("Error B12: Error retrieving all businesess")
            return
        }
        
        temp.forEach {$0.isFavorite = false}
        
        do {
            try dataController.viewContext.save()
        } catch {
            print("Error B13: Error saving businesses after trying to reset all isFavorite")
        }
    }
}
