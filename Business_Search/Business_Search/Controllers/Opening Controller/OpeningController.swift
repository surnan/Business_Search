//
//  AnotherTest.swift
//  Business_Search
//
//  Created by admin on 5/1/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData

let businessCellID = "businessCellID"
let _businessCellID = "_businessCellID"
let categoryCellID = "categoryCellID"

enum TableIndex:Int {
    case business = 0, category
}

class OpeningController: UIViewController, UISearchControllerDelegate, UISearchBarDelegate, UnBlurDelegate, OpenControllerDelegate {
    lazy var tableDataSource    = MyDataSource(dataController: dataController, latitude: latitude, longitude: longitude, model: model)
    lazy var tableDelegate      = MyDelegate(delegate: self, dd: tableDataSource)
    let model                   = OpeningModel()
    
    var getDataController           : DataController {return dataController}
    var getLatitude                 : Double {return latitude}
    var getLongitude                : Double  {return longitude}
    var getModel                    : MyDataSource {return tableDataSource}
    
    var latitude        : Double!                                 //MARK: Injected
    var longitude       : Double!                                 //MARK: Injected
    var moc             : NSManagedObjectContext!                 //Parent-Context
    var privateMoc      : NSManagedObjectContext!                 //Child-Context for CoreData Concurrency
    var dataController  : DataController!{                        //MARK: Injected
        didSet {
            moc                 = dataController.viewContext
            privateMoc          = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            privateMoc.parent   = moc
        }
    }
    
    var currentLocationID: NSManagedObjectID?                               //Used to connect newly downloaded Business to Location
    var doesLocationEntityExist = false                                     //set true after we create location or find location
    var urlsQueue               = [CreateYelpURLDuringLoopingStruct]()      //enumeration loop for semaphores
    

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
}
