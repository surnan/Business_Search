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


let defaultCellID = "defaultCellID"
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
        tableView.register(DefaultCell.self, forCellReuseIdentifier: defaultCellID)
        return tableView
    }()
    
    var fetchPredicate : NSPredicate? {
        didSet {
            NSFetchedResultsController<NSFetchRequestResult>.deleteCache(withName: nil) //Just in case I later turn on NSFetchResults Cache
            myFetchController?.fetchRequest.predicate = fetchPredicate
        }
    }

    var myFetchController: NSFetchedResultsController<Business>? { //+1
        didSet {    //+2
            if myFetchController == nil { //+3
                myFetchController = {   //+4
                    let fetchRequest: NSFetchRequest<Business> = Business.fetchRequest()
                    fetchRequest.predicate = self.fetchPredicate
                    let sortDescriptor = [NSSortDescriptor(key: "name", ascending: true)]
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
    

    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        let safe = view.safeAreaLayoutGuide
        tableView.anchor(top: safe.topAnchor, leading: safe.leadingAnchor, trailing: safe.trailingAnchor, bottom: safe.bottomAnchor)
        setupNavigationMenu()
        fetchPredicate = nil
        myFetchController = nil
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





