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

/*
 func numberOfSections(in tableView: UITableView) -> Int {
 return 1
 }
 
 func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 if isFiltering() {
 return filteredCandies.count
 }
 return candies.count
 }
 
 func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 let cell = tableView.dequeueReusableCell(withIdentifier: defaultCellID, for: indexPath) as! DefaultCell
 let candy: Candy
 if isFiltering() {
 candy = filteredCandies[indexPath.row]
 } else {
 candy = candies[indexPath.row]
 }
 cell.textLabel!.text = candy.name
 return cell
 }
 */

//let defaultCellID = "defaultCellID"
class OpeningController: UIViewController, NSFetchedResultsControllerDelegate, UISearchControllerDelegate, UISearchBarDelegate {
    
    var dataController: DataController!  //MARK: Injected
//    var tableView = UITableView()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DefaultCell.self, forCellReuseIdentifier: defaultCellID)
        return tableView
    }()
    
    
    
    
    
    
    var myFetchController: NSFetchedResultsController<Location>!
    var myCategories = [[Category]]()
    var myBusinesses = [Business]()
    var myLocations = [Location]()
    var currentLocation: Location!
    var doesLocationExist = false
    
    
    
    
    
    
    
    
    


    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        let safe = view.safeAreaLayoutGuide
        tableView.anchor(top: safe.topAnchor, leading: safe.leadingAnchor, trailing: safe.trailingAnchor, bottom: safe.bottomAnchor)
        setupNavigationMenu()
    }
    
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil) //Going to use same View to display results
        searchController.searchBar.scopeButtonTitles = ["All", "Chocolate", "Hard", "Other"]
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Candies"
//        searchController.
        return searchController
    }()
    
    
    
    
    
    
    
    
    
    
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





