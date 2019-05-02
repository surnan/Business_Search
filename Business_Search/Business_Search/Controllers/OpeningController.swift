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



let businessCellID = "businessCellID"


class OpeningController: UIViewController, NSFetchedResultsControllerDelegate, UISearchControllerDelegate, UISearchBarDelegate {
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
        tableView.register(DefaultCell.self, forCellReuseIdentifier: businessCellID)
        return tableView
    }()
    
    var fetchPredicate : NSPredicate? {
        didSet {
            NSFetchedResultsController<NSFetchRequestResult>.deleteCache(withName: nil) //Just in case I later turn on NSFetchResults Cache
            fetchBusinessController?.fetchRequest.predicate = fetchPredicate
        }
    }

    var fetchBusinessController: NSFetchedResultsController<Business>? { //+1
        didSet {    //+2
            if fetchBusinessController == nil { //+3
                fetchBusinessController = {   //+4
                    let fetchRequest: NSFetchRequest<Business> = Business.fetchRequest()
                    fetchRequest.predicate = self.fetchPredicate
                    
                    
//                    let sortDescriptor = [NSSortDescriptor(key: "name", ascending: true)]
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
        definesPresentationContext = true
    }
    
    
    func setupNavigationMenu(){
        let logo = UIImage(imageLiteralResourceName: "Inline-Logo")
        let imageView = UIImageView(image: logo)
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView
        navigationItem.searchController = searchController
    }
    
    
    var filteredCandies = [Candy]()
    var candies: [Candy] = [
        Candy(category:"Chocolate", name:"Chocolate Bar"),
        Candy(category:"Chocolate", name:"Chocolate Chip"),
        Candy(category:"Chocolate", name:"Dark Chocolate"),
        Candy(category:"Hard", name:"Lollipop"),
        Candy(category:"Hard", name:"Candy Cane"),
        Candy(category:"Hard", name:"Jaw Breaker"),
        Candy(category:"Other", name:"Caramel"),
        Candy(category:"Other", name:"Sour Chew"),
        Candy(category:"Other", name:"Gummi Bear"),
        Candy(category:"Other", name:"Candy Floss"),
        Candy(category:"Chocolate", name:"Chocolate Coin"),
        Candy(category:"Chocolate", name:"Chocolate Egg"),
        Candy(category:"Other", name:"Jelly Beans"),
        Candy(category:"Other", name:"Liquorice"),
        Candy(category:"Hard", name:"Toffee Apple"),
        Candy(category:"Other", name:"Gummi Bear"),
        Candy(category:"Other", name:"Candy Floss"),
        Candy(category:"Chocolate", name:"Chocolate Coin"),
        Candy(category:"Chocolate", name:"Chocolate Egg"),
        Candy(category:"Other", name:"Jelly Beans"),
        Candy(category:"Other", name:"Liquorice"),
        Candy(category:"Hard", name:"Toffee Apple")
    ]
}





