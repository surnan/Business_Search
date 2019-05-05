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
    
    
    var dataController: DataController!  //MARK: Injected
    var searchLocationCoordinate: CLLocationCoordinate2D!
    var searchLocation: Location!
    var doesLocationExist = false
    var urlsQueue = [CreateYelpURLDuringLoopingStruct]() //enumeration loop for semaphores
    var currentLocationID: NSManagedObjectID?
    
    var searchGroupIndex = 0 //Only accessed directly in 'func selectedScopeButtonIndexDidChange'
    var tableViewArrayType: Int {
        return searchGroupIndex
    }
    
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
    var fetchBusinessPredicate : NSPredicate? {
        didSet {
            NSFetchedResultsController<NSFetchRequestResult>.deleteCache(withName: nil) //Just in case I later turn on NSFetchResults Cache
            fetchBusinessController?.fetchRequest.predicate = fetchBusinessPredicate
        }
    }
    
    var fetchBusinessController: NSFetchedResultsController<Business>? { //+1
        didSet {    //+2
            if fetchBusinessController == nil { //+3
                fetchBusinessController = {   //+4
                    let fetchRequest: NSFetchRequest<Business> = Business.fetchRequest()
                    fetchRequest.predicate = self.fetchBusinessPredicate
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
    
    
    
    
    lazy var fetchCategoryPredicate : NSPredicate? = nil
    
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
                fetchRequest.predicate = fetchCategoryPredicate
                
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
    
    func resetAllPredicateRelatedVar() {
        fetchBusinessPredicate = nil
        fetchCategoryPredicate = nil
        fetchBusinessController = nil
        fetchCategoryNames = nil
    }
    
    
    var selectedCategoryPredicate: NSPredicate?
    
    var fetchCategoriesController: NSFetchedResultsController<Category>? { //+1
        didSet {    //+2
            if fetchCategoriesController == nil { //+3
                fetchCategoriesController = {   //+4
                    let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
                    fetchRequest.predicate = self.selectedCategoryPredicate
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        nothingFoundView.center = view.center
        view.insertSubview(nothingFoundView, aboveSubview: tableView)
        tableView.fillSuperview()
        setupNavigationMenu()
        resetAllPredicateRelatedVar()
        definesPresentationContext = true
    }
    
    
    func setupNavigationMenu(){
        let logo = UIImage(imageLiteralResourceName: "Inline-Logo")
        let imageView = UIImageView(image: logo)
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView
        navigationItem.searchController = searchController
        navigationItem.leftBarButtonItems = [UIBarButtonItem(title: "←", style: .done, target: self, action: #selector(handleBack)), UIBarButtonItem(title: "▶️", style: .done, target: self, action: #selector(handleDownloadBusinesses)), UIBarButtonItem(title: " ⏸", style: .done, target: self, action: #selector(JumpToBreakPoint))]
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete All", style: .done, target: self, action: #selector(handleDeleteAll))
    }

    
    @objc func handleBack(){
        navigationController?.popViewController(animated: true)
    }
    
    
    @objc func handleDownloadBusinesses(){

        deleteAll()
        ////////////////////////////////////////////////
        self.fetchBusinessController = nil
        self.fetchCategoriesController = nil
        ////////////////////////////////////////////////

        _ = YelpClient.getNearbyBusinesses(latitude: latitude, longitude: longitude, completion: handleLoadBusinesses(inputData:result:))
        
    }
    
    @objc func JumpToBreakPoint(total: Int){
        print("")
        
        
        ////////////////////////////////////////////////
        print("fetchBusiness.FetchedObject.count - ", fetchBusinessController?.fetchedObjects?.count ?? -999)
        print("fetchCategoryArray.count - ", fetchCategoryNames?.count ?? -999)
        ////////////////////////////////////////////////
        
        
    }
    
    //MARK:- Below is Bar Button functions or Called in ViewDidLoad()
    @objc func handleDeleteAll(){
        deleteAll()
    }
    
    
    func deleteAll(){
        doesLocationExist = false
        let context: NSManagedObjectContext!  = dataController.backGroundContext
        context.perform {
            let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Location")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetch)
            
            do {
                _  = try context.execute(deleteRequest) as! NSBatchDeleteResult
                
                self.fetchBusinessController = nil
                self.fetchCategoriesController = nil
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                //  context.reset()
            } catch {
                print("Error deleting All \(error)")
            }
        }
    }
}

//po String(data: data, format: .utf8)
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
                newLocation.saveBusinessesAndCategories(yelpData: data, context: backgroundContext) //2
                self.buildURLsQueueForDownloadingBusinesses(total: data.total)    //Because background context, best way to time save happens first
            } catch {
                print("Error saving func addLocation() --\n\(error)")
            }
        }
    }
    
    func handleLoadBusinesses(inputData: CreateYelpURLDuringLoopingStruct?, result: Result<YelpBusinessResponse, NetworkError>){
        switch result {
        case .failure(let error):
            if error == NetworkError.needToRetry || error == NetworkError.tooManyRequestsPerSecond {
                print("handleLoadBusiness --> Retry -> \(error))")
            } else {
                print("Error that is not 'needToRetry' --> error = \(error)")
            }
        case .success(let data):
            if !doesLocationExist {
                createLocation(data: data)
                doesLocationExist = true
            } else {
                let filterIndex = urlsQueue.firstIndex { (element) -> Bool in
                    guard let inputData = inputData else {return false}
                    return element.offset == inputData.offset
                }
                if let indexToDelete = filterIndex {
                    urlsQueue.remove(at: indexToDelete)
                }
                
                dataController.persistentContainer.performBackgroundTask {[unowned self] (context) in
                    //Giving Core Data the chance to perform multiple instances in parallel
                    let currentLocation = context.object(with: self.currentLocationID!) as! Location
                    currentLocation.saveBusinessesAndCategories(yelpData: data, context: context)
                }
            }
        }
    }
    
    func buildURLsQueueForDownloadingBusinesses(total: Int){
        for index in stride(from: limit, to: recordCountAtLocation, by: limit){
            urlsQueue.append(CreateYelpURLDuringLoopingStruct(latitude: latitude, longitude: longitude, offset: index))
        }
        downloadYelpBusinesses()
    }
    
    func downloadYelpBusinesses(){
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

