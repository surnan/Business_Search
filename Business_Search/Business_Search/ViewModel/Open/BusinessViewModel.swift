//
//  OpenViewModel.swift
//  Business_Search
//
//  Created by admin on 7/29/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import CoreData

class BusinessViewModel {
    private var delegate: OpenControllerType
    private var dataController: DataController

    init(delegate: OpenControllerType, dataController: DataController) {
        self.dataController = dataController
        self.delegate = delegate
    }

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
    
    //MARK:- NON-Private
    var getCount: Int {return fetchBusinessController?.fetchedObjects?.count ?? 0}
    var isEmpty: Bool {return fetchBusinessController?.fetchedObjects?.count == 0}
    func reload(){fetchBusinessController = nil}

    func search(search: String?){
        if let search = search {
            fetchBusinessPredicate  = NSPredicate(format: "name CONTAINS[cd] %@", argumentArray: [search])
            reload()
        } else {
            fetchBusinessPredicate  = nil
            reload()
        }
        reload()
    }
    
    func search(id: String){
        fetchBusinessPredicate = NSPredicate(format: "id CONTAINS[cd] %@", argumentArray: [id])
        reload()
    }
    
    func isFavorite(at indexPath: IndexPath)->Bool{
        let currentBusiness = fetchBusinessController?.object(at: indexPath)
        return currentBusiness?.isFavorite ?? false
    }
    
    
    func objectAt(indexPath: IndexPath)-> Business {
        return fetchBusinessController!.object(at: indexPath)   //It's OK for forced-unwrap because it has to exist at this stage
    }
    
    
    func fetchedObjects() -> [Business]{
        return fetchBusinessController!.fetchedObjects ?? []
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
                    
                    let sortDescriptor = NSSortDescriptor(keyPath: \Business.name, ascending: true)
                    let sortDescriptor2 = NSSortDescriptor(keyPath: \Business.isFavorite, ascending: false)
                    fetchRequest.sortDescriptors = [sortDescriptor2, sortDescriptor]
                    let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                               managedObjectContext: dataController.viewContext,
                                                                               sectionNameKeyPath: nil,
                                                                               cacheName: nil)
                    do {
                        print("Performing Business Fetch with: \n   \(fetchRequest.predicate!)")
                        try aFetchedResultsController.performFetch()
                    } catch let error {
                        fatalError("Unresolved error \(error)")
                    }
                    return aFetchedResultsController
                }() //-4
            }   //-3
        }   //-2
    }   //-1
}