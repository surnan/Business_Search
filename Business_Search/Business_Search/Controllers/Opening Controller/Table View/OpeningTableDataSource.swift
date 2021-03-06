//
//  OpeningControllerTableSource.swift
//  Business_Search
//
//  Created by admin on 7/1/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class OpeningTableDataSource: NSObject, UITableViewDataSource{
    var dataController: DataController!
    var latitude: Double!
    var longitude: Double!
    
    var model: OpeningModel!
    
    init(dataController: DataController, latitude: Double, longitude: Double, model: OpeningModel) {
        super.init()
        self.dataController = dataController
        self.latitude = latitude
        self.longitude = longitude
        self.model = model
    }
    
    var searchGroupIndex = 0                                    //'func selectedScopeButtonIndexDidChange'
    var tableViewArrayType: Int { return searchGroupIndex }     //protect searchGroupIndex
    
    //MARK:- Predicates
    lazy var fetchPredicateInput: String? = nil
    var selectedCategoryPredicate: NSPredicate? {
        didSet {
            NSFetchedResultsController<NSFetchRequestResult>.deleteCache(withName: nil) //Just in case
            fetchCategoriesController?.fetchRequest.predicate = fetchBusinessPredicate
        }
    }
    
    var fetchBusinessPredicate : NSPredicate? {
        didSet {
            NSFetchedResultsController<NSFetchRequestResult>.deleteCache(withName: nil) //Just in case
            fetchBusinessController?.fetchRequest.predicate = fetchBusinessPredicate
        }
    }
    var fetchFavoritePredicate: NSPredicate?
    
    lazy var fetchCategoryArrayNamesPredicate: NSPredicate? = nil
    var predicateTest = false
    
    //aFetchedResultsController.delegate = self
    var fetchBusinessController: NSFetchedResultsController<Business>? { //+1
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
                        print("Performing Business Fetch with: \n   \(fetchRequest.predicate)")
                        try aFetchedResultsController.performFetch()
                    } catch let error {
                        fatalError("Unresolved error \(error)")
                    }
                    return aFetchedResultsController
                }() //-4
            }   //-3
        }   //-2
    }   //-1
    
    var fetchCategoriesController: NSFetchedResultsController<Category>? { //+1
        didSet {    //+2
            if fetchCategoriesController == nil { //+3
                fetchCategoriesController = {   //+4
                    let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
                    if let _selectedPredicate = selectedCategoryPredicate {
                        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [_selectedPredicate])
                    }
                    let sortDescriptor = NSSortDescriptor(keyPath: \Category.title, ascending: true)
                    fetchRequest.sortDescriptors = [ sortDescriptor]
                    let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                               managedObjectContext: dataController.viewContext,
                                                                               sectionNameKeyPath: nil,
                                                                               cacheName: nil)
                    do {
                        try aFetchedResultsController.performFetch()
                    } catch let error {
                        fatalError("Unresolved error \(error)")
                    }
                    return aFetchedResultsController
                }() //-4
            }   //-3
        }   //-2
    }   //-1
    
    var fetchFavoritesController: NSFetchedResultsController<Favorites>?{
        didSet{
            if fetchFavoritesController == nil {
                fetchFavoritesController = {
                    let fetchRequest: NSFetchRequest<Favorites> = Favorites.fetchRequest()
                    fetchRequest.predicate = fetchFavoritePredicate
                    let sortDescriptor = NSSortDescriptor(keyPath: \Favorites.id, ascending: true)
                    fetchRequest.sortDescriptors = [sortDescriptor]
                    let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                               managedObjectContext: dataController.viewContext,
                                                                               sectionNameKeyPath: nil,
                                                                               cacheName: nil)
                    do {
                        try aFetchedResultsController.performFetch()
                    } catch let error {
                        fatalError("Unresolved error \(error)")
                    }
                    return aFetchedResultsController
                }()
            }
        }
    }
    
    
    //latitude and longitude MUST when this Controller is created
    lazy var predicateBusinessLatitude = NSPredicate(format: "%K == %@", argumentArray: [#keyPath(Business.parentLocation.latitude), latitude!])
    lazy var predicateBusinessLongitude = NSPredicate(format: "%K == %@", argumentArray: [#keyPath(Business.parentLocation.longitude), longitude!])
    lazy var predicateCategoryLatitude = NSPredicate(format: "%K == %@", argumentArray: [#keyPath(Category.business.parentLocation.latitude), latitude!])
    lazy var predicateCategoryLongitude = NSPredicate(format: "%K == %@", argumentArray: [#keyPath(Category.business.parentLocation.longitude), longitude!])
    
    var fetchCategoryNames: [String]? { //Populate Search Group listings
        didSet {
            if fetchCategoryNames == nil {
                //By default, returns .ManagedObjectResultType = Actual Objects
                // .dictionaryResultType used for 'returnsDistinctResults'
                let fetchRequest = NSFetchRequest<NSDictionary>(entityName: "Category")
                fetchRequest.resultType = .dictionaryResultType
                fetchRequest.propertiesToFetch = ["title"]
                fetchRequest.returnsDistinctResults = true
                let sortDescriptor = [NSSortDescriptor(key: "title", ascending: true)]
                fetchRequest.sortDescriptors = sortDescriptor
                
                var predicate: [NSPredicate] = [predicateCategoryLatitude, predicateCategoryLongitude]
                if let _predicate = fetchCategoryArrayNamesPredicate {predicate.append(_predicate)}
                let openingControllerPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicate)
                
                var filterControllerPredicate = UserAppliedFilter.shared.getCategoryPredicate()
                filterControllerPredicate.append(openingControllerPredicate)
                fetchRequest.predicate = NSCompoundPredicate(type: .and, subpredicates: filterControllerPredicate)
                
                let controller = NSFetchedResultsController(
                    fetchRequest: fetchRequest,
                    managedObjectContext: dataController.viewContext,
                    sectionNameKeyPath: nil,    // just for demonstration: nil = dont split into section
                    cacheName: nil              // and nil = dont cache
                )
                
                do {
                    try controller.performFetch()
                    let temp = controller.fetchedObjects
                    var answer = [String]()
                    temp?.forEach({ (element) in
                        let tempString = element.value(forKey: "title") as! String
                        answer.append(tempString)
                    })
                    fetchCategoryNames = answer
                } catch {
                    print("Fail to PerformFetch inside categoryFinalArray:")
                }
            }
        }
    }
    
    var fetchLocationController: NSFetchedResultsController<Location>? {
        didSet {
            if fetchLocationController == nil {
                fetchLocationController = {
                    let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
                    let sortDescriptor = NSSortDescriptor(keyPath: \Location.latitude, ascending: true)
                    fetchRequest.sortDescriptors = [ sortDescriptor]
                    let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                               managedObjectContext: dataController.viewContext,
                                                                               sectionNameKeyPath: nil,
                                                                               cacheName: nil)
                    do {
                        try aFetchedResultsController.performFetch()
                    } catch let error {
                        fatalError("Unresolved error \(error)")
                    }
                    return aFetchedResultsController
                }()
            }
        }
    }
}




