//
//  AnotherTest.swift
//  Business_Search
//
//  Created by admin on 5/1/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData
import MapKit


let businessCellID = "businessCellID"
let _businessCellID = "_businessCellID"
let categoryCellID = "categoryCellID"

class OpeningController: UIViewController, NSFetchedResultsControllerDelegate, UISearchControllerDelegate, UISearchBarDelegate {
    
    var dataController: DataController!                 //MARK: Injected
    var possibleInsertLocationCoordinate: CLLocation!   //SearchByMapController
    var searchLocation: Location!                       //SearchController textField
    
    var delegate: MenuControllerProtocol?       //Get Coordinates from 'Search Nearby'
    var currentLocationID: NSManagedObjectID?   //Used to connect newly downloaded Business to Location
    
    var locationPassedIn = false            //after delegate.stopGPS(), NSNotification still fires a couple more times
    var doesLocationEntityExist = false     //set true after we create location or find location
    
    var urlsQueue = [CreateYelpURLDuringLoopingStruct]()    //enumeration loop for semaphores
    var searchGroupIndex = 0                                //Only accessed directly in 'func selectedScopeButtonIndexDidChange'
    var tableViewArrayType: Int { return searchGroupIndex } //Enables functions to know which SearchGroup is selected
    
    var myQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    let activityView: UIActivityIndicatorView = {
        let activityVC = UIActivityIndicatorView()
        activityVC.hidesWhenStopped = true
        activityVC.style = .gray
        return activityVC
    }()
    
    enum TableIndex:Int {
        case business = 0, category
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(BusinessCell.self, forCellReuseIdentifier: businessCellID)
        tableView.register(CategoryCell.self, forCellReuseIdentifier: categoryCellID)
        tableView.register(_BusinessCell.self, forCellReuseIdentifier: _businessCellID)
        return tableView
    }()
    
    let nothingFoundView: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 350, height: 350))
        label.backgroundColor = .clear
        label.alpha = 0
        label.text = "That's all Folks"
        label.textAlignment = .center
        label.isUserInteractionEnabled = false
        let textAttributes:[NSAttributedString.Key: Any] = [
            NSAttributedString.Key.strokeColor: UIColor.lightGray,
            NSAttributedString.Key.foregroundColor: UIColor.green,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 30)!,
            NSAttributedString.Key.strokeWidth: -1.0
        ]
        label.attributedText = NSAttributedString(string: "No matches found", attributes: textAttributes)
        return label
    }()
    
    //MARK:- Predicates
    var currentLatitude = 0.0
    var currentLongitude = 0.0
    
    //lazy var predicateLatitude = NSPredicate(format: "%K == %@", argumentArray: [#keyPath(Business.parentLocation.latitude), currentLatitude])
    //lazy var predicateLongitude = NSPredicate(format: "%K == %@", argumentArray: [#keyPath(Business.parentLocation.longitude), currentLongitude])
    
    lazy var fetchPredicateInput: String? = nil
    var selectedCategoryPredicate: NSPredicate? {
        didSet {
            NSFetchedResultsController<NSFetchRequestResult>.deleteCache(withName: nil) //Just in case we use NSFetchResults Cache
            fetchCategoriesController?.fetchRequest.predicate = fetchBusinessPredicate
        }
    }
    
    var fetchBusinessPredicate : NSPredicate? {
        didSet {
            NSFetchedResultsController<NSFetchRequestResult>.deleteCache(withName: nil) //Just in case we use NSFetchResults Cache
            fetchBusinessController?.fetchRequest.predicate = fetchBusinessPredicate
        }
    }
    
    lazy var fetchCategoryArrayNamesPredicate: NSPredicate? = nil
    var predicateTest = false
    
    var fetchBusinessController: NSFetchedResultsController<Business>? { //+1
        didSet {    //+2
            if fetchBusinessController == nil { //+3
                fetchBusinessController = {   //+4
                    let fetchRequest: NSFetchRequest<Business> = Business.fetchRequest()
                    if let fetchBusinessPredicate = fetchBusinessPredicate {
                        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fetchBusinessPredicate,
                                                                                                     predicateLatitude,
                                                                                                     predicateLongitude])
                    } else {
                        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicateLatitude,
                                                                                                     predicateLongitude])
                    }
                    let sortDescriptor = NSSortDescriptor(keyPath: \Business.name, ascending: true)
                    fetchRequest.sortDescriptors = [ sortDescriptor]
                    let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                               managedObjectContext: dataController.viewContext,
                                                                               sectionNameKeyPath: nil,
                                                                               cacheName: nil)
                    aFetchedResultsController.delegate = self
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
    
    
    var fetchCategoriesController: NSFetchedResultsController<Category>? { //+1
        didSet {    //+2
            if fetchCategoriesController == nil { //+3
                fetchCategoriesController = {   //+4
                    let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
                    fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [selectedCategoryPredicate!])
                    let sortDescriptor = NSSortDescriptor(keyPath: \Category.title, ascending: true)
                    fetchRequest.sortDescriptors = [ sortDescriptor]
                    let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                               managedObjectContext: dataController.viewContext,
                                                                               sectionNameKeyPath: nil,
                                                                               cacheName: nil)
                    aFetchedResultsController.delegate = self
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
    
    lazy var predicateLatitude = NSPredicate(format: "%K == %@", argumentArray: [#keyPath(Business.parentLocation.latitude), currentLatitude])
    lazy var predicateLongitude = NSPredicate(format: "%K == %@", argumentArray: [#keyPath(Business.parentLocation.longitude), currentLongitude])
    
    lazy var predicateCatLatitude = NSPredicate(format: "%K == %@", argumentArray: [#keyPath(Category.business.parentLocation.latitude), currentLatitude])
    lazy var predicateCatLongitude = NSPredicate(format: "%K == %@", argumentArray: [#keyPath(Category.business.parentLocation.longitude), currentLongitude])
    
    
    var fetchCategoryNames: [String]? {   //+1
        didSet {    //+2
            if fetchCategoryNames == nil {    //+3
                //By default, returns .ManagedObjectResultType = Actual Objects
                // .dictionaryResultType used for 'returnsDistinctResults'
                let fetchRequest = NSFetchRequest<NSDictionary>(entityName: "Category")
                fetchRequest.resultType = .dictionaryResultType
                fetchRequest.propertiesToFetch = ["title"]
                fetchRequest.returnsDistinctResults = true
                let sortDescriptor = [NSSortDescriptor(key: "title", ascending: true)]
                fetchRequest.sortDescriptors = sortDescriptor
                
                if let fetchCategoryArrayNamesPredicate = fetchCategoryArrayNamesPredicate {
                    fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fetchCategoryArrayNamesPredicate,
                                                                                                 predicateCatLatitude,
                                                                                                 predicateCatLongitude])
                } else {
                    fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicateCatLatitude,
                                                                                                 predicateCatLongitude])
                }
                
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
            }   //-3
        }   //-2
    }   //-1
    
    
    var fetchLocationController: NSFetchedResultsController<Location>? { //+1
        didSet {    //+2
            if fetchLocationController == nil { //+3
                fetchLocationController = {   //+4
                    let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
                    let sortDescriptor = NSSortDescriptor(keyPath: \Location.latitude, ascending: true)
                    fetchRequest.sortDescriptors = [ sortDescriptor]
                    let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                               managedObjectContext: dataController.viewContext,
                                                                               sectionNameKeyPath: nil,
                                                                               cacheName: nil)
                    aFetchedResultsController.delegate = self
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
    
    
    
    //MARK:- UI
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil) //Going to use same View to display results
        searchController.searchBar.scopeButtonTitles = ["Business", "Category"]
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Enter search term ..."
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.barStyle = .black
        return searchController
    }()
}

//po String(data: data, format: .utf8)

