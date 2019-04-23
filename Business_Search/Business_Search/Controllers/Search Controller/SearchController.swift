//
//  FirstController.swift
//  Business_Search
//
//  Created by admin on 4/16/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData

struct YelpCategoryElement: Equatable {
    var alias: String
    var title: String
    var businessID: String
    static func == (lhs: YelpCategoryElement, rhs: YelpCategoryElement) -> Bool {
        return lhs.title == rhs.title
    }
}

struct YelpBusinessElement {
    var title: String
    var address: String
    var state: String
    var zipCode: String
    var businessID: String
}

class SearchController: UIViewController, UISearchControllerDelegate{
    var urlSessionTask: URLSessionDataTask?
    var dataController: DataController!
    var myFetchController: NSFetchedResultsController<Location>!
    var locationArray = [Location]()
    var yelpCategoryArray = [[YelpCategoryElement]]()
    var yelpBusinessArray = [YelpBusinessElement]()
    let resultsTableController = ResultsController()
    //var resultsTableController: ResultsTableViewController? //Can't make it work
    

    lazy var searchController: UISearchController = {
        var search = UISearchController(searchResultsController: resultsTableController)
        search.delegate = self
        search.searchResultsUpdater = resultsTableController
        search.searchBar.delegate = resultsTableController
        search.searchBar.placeholder = "Search place"
        search.searchBar.barTintColor = navigationController?.navigationBar.barTintColor
        search.searchBar.tintColor = self.view.tintColor
        search.searchBar.scopeButtonTitles = ["Business Names", "Categories"]
        search.searchBar.barStyle = .black      // TyLocationg Font = white
        //search.obscuresBackgroundDuringPresentation = true    //removes .lightContent from navigation item
        
        //DON'T SEE IT
        //        search.searchBar.sizeToFit()
        //        search.dimsBackgroundDuringPresentation = true
        //        search.loadViewIfNeeded()
        //        search.hidesNavigationBarDuringPresentation = false
        //        search.searchBar.barTintColor = UIColor.orange
        return search
    }()
    
    func buildYelpCategoryArray(data: YelpBusinessResponse){
        var index = -1
        data.businesses.forEach { (business) in
            index += 1
            guard let title = business.name, let id = business.id, let address = business.location.address1,
                let state = business.location.city, let zipCode = business.location.zip_code else {return}
            let tempBusiness = YelpBusinessElement(title: title, address: address, state: state, zipCode: zipCode, businessID: id)
            yelpBusinessArray.append(tempBusiness)
            business.categories.forEach({ (category) in
                guard let title = category.title, let alias = category.alias else {return}
                print("title = \(title)")
                let temp = YelpCategoryElement(alias: alias, title: title, businessID: id)
                if yelpCategoryArray.isEmpty {
                    yelpCategoryArray.append([temp])
                    return
                }
                for i in 0 ... yelpCategoryArray.count - 1 {
                    if yelpCategoryArray[i].first == temp {
                        yelpCategoryArray[i].append(temp)
                        break
                    } else if i == yelpCategoryArray.count - 1 {
                        yelpCategoryArray.append([temp])
                        break
                    }
                }
            })
        }
    }
    
    func addLocation(data: YelpBusinessResponse){
        let backgroundContext = dataController.backGroundContext!
        let newLocation = Location(context: backgroundContext)
        newLocation.latitude = data.region.center.latitude
        newLocation.longititude = data.region.center.longitude
        newLocation.totalBusinesses = Int32(data.total)
        newLocation.radius = Int32(radius) //AppDelegate
        buildYelpCategoryArray(data: data)
        do {
            try backgroundContext.save()
            newLocation.addBusinesses(yelpData: data, dataController: dataController)
        } catch {
            print("Error saving func addLocation() --\n\(error)")
        }
    }
}
