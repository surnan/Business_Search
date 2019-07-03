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

enum TableIndex:Int {
    case business = 0, category
}

class OpeningController: UIViewController, NSFetchedResultsControllerDelegate, UISearchControllerDelegate, UISearchBarDelegate, UnBlurDelegate, OpenControllerDelegate {
    
    
    var getDataController: DataController {return dataController}
    var getLatitude: Double {return latitude}
    var getLongitude: Double  {return longitude}
    var getModel: MyDataSource {return model}
    func currentSelected(_ indexPath: IndexPath) {print(indexPath)}
    
    func reloadData(){tableView.reloadData()}
    
    
    
    var latitude: Double!                                       //MARK: Injected
    var longitude: Double!                                      //MARK: Injected
    var moc: NSManagedObjectContext!                            //Parent-Context
    var privateMoc: NSManagedObjectContext!                     //Child-Context for CoreData Concurrency
    var dataController: DataController!{                        //MARK: Injected
        didSet {
            moc = dataController.viewContext
            privateMoc = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            privateMoc.parent = moc
        }
    }
    
    var currentLocationID: NSManagedObjectID?                   //Used to connect newly downloaded Business to Location
    var doesLocationEntityExist = false                         //set true after we create location or find location
    var urlsQueue = [CreateYelpURLDuringLoopingStruct]()        //enumeration loop for semaphores
//    var searchGroupIndex = 0                                    //Only accessed directly in 'func selectedScopeButtonIndexDidChange'
//    var tableViewArrayType: Int { return searchGroupIndex }     //Enables functions to know which SearchGroup is selected
    
    func animateResultsAreFilteredLabel(){
        if !UserAppliedFilter.shared.isFilterOn {return}
        print("B - Filter executed")
        
        let resultsAreFilteredLabel: UILabel = {
            let label = UILabel()
            label.backgroundColor = .black
            label.textColor = .white
            label.textAlignment = .center
            label.text = "Partial results due to filter options..."
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        view.addSubview(resultsAreFilteredLabel)
        let safe = view.safeAreaLayoutGuide
        resultsAreFilteredLabel.anchor(top: safe.topAnchor, leading: safe.leadingAnchor, trailing: safe.trailingAnchor)
        resultsAreFilteredLabel.alpha = 1
        
        UIView.animate(withDuration: 1.5, animations: {
            resultsAreFilteredLabel.alpha = 0
        }) { (_) in
            resultsAreFilteredLabel.removeFromSuperview()
        }
    }
    
    
    lazy var blurredEffectView2: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = view.bounds
        return blurredEffectView
    }()
    
    func undoBlur() {
        blurredEffectView2.removeFromSuperview()
        navigationController?.setNavigationBarHidden(false, animated: true)
        doesLocationEntityExist = false
        readOrCreateLocation()
        animateResultsAreFilteredLabel()
    }
    
    
    let tableDelegate = MyDelegate()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        //tableView.delegate = self
        tableView.delegate = tableDelegate
        tableView.dataSource = model
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
    /*
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
                    
                    var predicate: [NSPredicate] = [predicateBusinessLatitude, predicateBusinessLongitude]
                    if let _predicate = fetchBusinessPredicate { predicate.append(_predicate)}
                    let openingControllerPredicate =  NSCompoundPredicate(andPredicateWithSubpredicates: predicate)
                
                    var filterControllerPredicate = UserAppliedFilter.shared.getBusinessPredicate()    //FilterController() & Singleton
                    filterControllerPredicate.append(openingControllerPredicate)
                    
                    fetchRequest.predicate = NSCompoundPredicate(type: .and, subpredicates: filterControllerPredicate)
                    
                    let sortDescriptor = NSSortDescriptor(keyPath: \Business.name, ascending: true)
                    let sortDescriptor2 = NSSortDescriptor(keyPath: \Business.isFavorite, ascending: false)
                    
                    fetchRequest.sortDescriptors = [sortDescriptor2, sortDescriptor]
                    
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
                    if let _selectedPredicate = selectedCategoryPredicate {
                        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [_selectedPredicate])
                    }
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
    
    var fetchFavoritePredicate: NSPredicate?
    
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
                    aFetchedResultsController.delegate = self
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
                    aFetchedResultsController.delegate = self
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
    */
    
    //MARK:- UI
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.scopeButtonTitles = ["Business", "Category"]
        searchController.obscuresBackgroundDuringPresentation = false
        
        //searchController.searchBar.barStyle = .black
        searchController.searchBar.tintColor = UIColor.white
        searchController.searchBar.barTintColor = UIColor.white
        searchController.searchBar.placeholder = "Enter search term ..."
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        
        //Setting background for search controller
        if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            if let backgroundview = textfield.subviews.first {
                backgroundview.backgroundColor = UIColor.white
                backgroundview.layer.cornerRadius = 10
                backgroundview.clipsToBounds = true
            }
        }
        return searchController
    }()
    
    //MARK:-  Outsourcing Data Source
    lazy var model = MyDataSource(dataController: dataController, latitude: latitude, longitude: longitude)
    
    
    
}
