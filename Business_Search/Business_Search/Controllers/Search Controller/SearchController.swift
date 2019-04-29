//
//  FirstController.swift
//  Business_Search
//
//  Created by admin on 4/16/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData


class SearchController: UIViewController, UISearchControllerDelegate, NSFetchedResultsControllerDelegate{
    //MARK: Injected
    var dataController: DataController!
    var myFetchController: NSFetchedResultsController<Business>!
    
    var myCategories = [[Category]]()
    var myBusinesses = [Business]()
    var myLocations = [Location]()
    
    
    
    //MARK: Local
    var categories = [[YelpCategoryElement]]()
    var businesses = [YelpBusinessElement]()
    var currentLocationID: NSManagedObjectID?
    var urlSessionTask: URLSessionDataTask?
    var urlsQueue = [YelpGetNearbyBusinessStruct]() //enumeration loop for semaphores
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
    
    
    
    func loadCategoriesAndBusinessesIntoArrays(data: YelpBusinessResponse){
        var index: Int
        if categories.isEmpty {
            index = -1  //index incremented by one once array initialized
        } else {
            index = businesses.count - 1
        }
        data.businesses.forEach { (currentBusiness) in
            businesses.append(YelpBusinessElement(title: currentBusiness.name ?? "",
                                                  address: currentBusiness.location.display_address.first ?? "",
                                                  state: currentBusiness.location.state ?? "",
                                                  zipCode: currentBusiness.location.zip_code ?? "",
                                                  businessID: currentBusiness.id ?? ""))
            index += 1
            currentBusiness.categories.forEach({ (currentCategory) in
                let newCategory = YelpCategoryElement(alias: currentCategory.alias ?? "", title: currentCategory.title ?? "", businessID: currentBusiness.id ?? "")
                if categories.isEmpty {
                    categories.append([newCategory])
                    return
                }
                for i in 0 ... categories.count - 1 {
                    if categories[i].first == newCategory {
                        categories[i].append(newCategory)
                        break
                    } else if i == categories.count - 1 {
                        categories.append([newCategory])
                        break
                    }
                }
            })
        }
    }
    
    func convertBusinessToCategories(){
         var totalIndex = 0
        myBusinesses.forEach { (currentBusiness) in
            let categoriesOnThisBusiness: [Category] = (currentBusiness.categories?.toArray())!
            categoriesOnThisBusiness.forEach({ (currentCategory) in
                
                if myCategories.isEmpty {
                    myCategories.append([currentCategory])
                    return
                }
                
               
                for i in 0 ..< myCategories.count {
                    totalIndex += 1
                    let doesItMatch = (myCategories[i].first?.matches(rhs: currentCategory))!
                    print("totalIndex = \(totalIndex) ... i = \(i) ... doesItMatch = \(doesItMatch)... \nleft = \(String(describing: myCategories[i].first)) ... \nright = \(currentCategory)\n\n\n\n")
                    if doesItMatch {
                        print("DOES_IT_MATCH = true")
                        myCategories[i].append(currentCategory)
                        break
                    } else if i == myCategories.count - 1 {
                        print("DOES_IT_MATCH = false")
                        myCategories.append([currentCategory])
                    }
                }
            })
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func fetchDataToMakeBusinessArray2(){
        let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
        let predicate = NSPredicate(format: "(longitude == %@) AND (latitude == %@)", argumentArray: [longitude, latitude])
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "totalBusinesses", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            myLocations = try dataController.backGroundContext.fetch(fetchRequest)
            myLocations.first?.businesses?.forEach{
                myBusinesses.append($0 as! Business)
            }
        } catch {
            print("Error = \(error)")
        }
    }
    
    

}

extension NSSet {
    func toArray<T>() -> [T] {
        let array = self.map({ $0 as! T})
        return array
    }
}
