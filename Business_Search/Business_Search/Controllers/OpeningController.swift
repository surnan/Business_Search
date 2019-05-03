//
//  AnotherTest.swift
//  Business_Search
//
//  Created by admin on 5/1/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData

struct Candy {
    let category : String
    let name : String
}


//var fetchRequestPredicate = NSCompoundPredicate()
//let expressionLHS = NSExpression(forKeyPath: item)
//let expressionRHS = NSExpression(forConstantValue: searchText)
//let comparisonPredicate = NSComparisonPredicate(leftExpression: expressionLHS,
//                                                rightExpression: expressionRHS,
//                                                modifier: .direct,
//                                                type: .contains,
//                                                options: [.caseInsensitive])





let businessCellID = "businessCellID"
let categoryCellID = "categoryCellID"


class OpeningController: UIViewController, NSFetchedResultsControllerDelegate, UISearchControllerDelegate, UISearchBarDelegate {
    
    var GROUP_INDEX = 0 //WILL BE SUBSITITUED WITH INT ENUM
    
    
    var dataController: DataController!  //MARK: Injected
    var myCategories = [[Category]]()
    var myLocations = [Location]()
    var currentLocation: Location!
    var doesLocationExist = false
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(BusinessCell.self, forCellReuseIdentifier: businessCellID)
        tableView.register(CategoryCell.self, forCellReuseIdentifier: categoryCellID)
        return tableView
    }()
    
    var fetchPredicate : NSPredicate? {
        didSet {
            NSFetchedResultsController<NSFetchRequestResult>.deleteCache(withName: nil) //Just in case I later turn on NSFetchResults Cache
            fetchBusinessController?.fetchRequest.predicate = fetchPredicate
            fetchCategoryController?.fetchRequest.predicate = fetchPredicate
        }
    }

    var fetchBusinessController: NSFetchedResultsController<Business>? { //+1
        didSet {    //+2
            if fetchBusinessController == nil { //+3
                fetchBusinessController = {   //+4
                    let fetchRequest: NSFetchRequest<Business> = Business.fetchRequest()
                    fetchRequest.predicate = self.fetchPredicate
                    let sortDescriptor2 = NSSortDescriptor(keyPath: \Business.name, ascending: true)
                    fetchRequest.sortDescriptors = [ sortDescriptor2]
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
    
    
    //By default, fetch returns .ManagedObjectResultType = Actual Objects
    // This will be .dictionaryResultType  = {"Property" : value}
    var fetchDictionaryCategoryController: NSFetchedResultsController<Category>? { //+1
        didSet {    //+2
            if fetchCategoryController == nil { //+3
                fetchCategoryController = {   //+4
                    let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
                    fetchRequest.predicate = self.fetchPredicate
                    let sortDescriptor = [NSSortDescriptor(key: "title", ascending: true)]
                    fetchRequest.sortDescriptors = sortDescriptor
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
    
    
    
    
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil) //Going to use same View to display results
        searchController.searchBar.scopeButtonTitles = ["Business", "Category"]
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Enter search term ..."
        searchController.searchBar.barStyle = .black
                searchController.searchBar.delegate = self
                searchController.searchResultsUpdater = self
        return searchController
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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        nothingFoundView.center = view.center
        view.insertSubview(nothingFoundView, aboveSubview: tableView)
        tableView.fillSuperview()
        setupNavigationMenu()
        fetchPredicate = nil
        fetchBusinessController = nil
        fetchCategoryController = nil
        definesPresentationContext = true
        
//        fetchResultsGetCategoriesAndCount()
//        categoryFinalArray.forEach{
//            print("CategoryFinalArray --> \($0)")
//        }
        
    }

    var fetchCategoryController: NSFetchedResultsController<Category>? { //+1
        didSet {    //+2
            if fetchCategoryController == nil { //+3
                fetchCategoryController = {   //+4
                    let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
                    fetchRequest.predicate = self.fetchPredicate
                    let sortDescriptor = [NSSortDescriptor(key: "title", ascending: true)]
                    fetchRequest.sortDescriptors = sortDescriptor
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

    
    
    lazy var categoryFinalArray: [String] = {   //+1
        let fetchRequest = NSFetchRequest<NSDictionary>(entityName: "Category")
        fetchRequest.resultType = .dictionaryResultType
        fetchRequest.propertiesToFetch = ["title"]
        fetchRequest.returnsDistinctResults = true
        let sortDescriptor = [NSSortDescriptor(key: "title", ascending: true)]
        fetchRequest.sortDescriptors = sortDescriptor
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
            
            
            return answer
        } catch {
            print("Fail to PerformFetch inside categoryFinalArray:")
        }
        return []
    }() //-1
    

    
    
    
    func setupNavigationMenu(){
        let logo = UIImage(imageLiteralResourceName: "Inline-Logo")
        let imageView = UIImageView(image: logo)
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView
        navigationItem.searchController = searchController
    }
}
