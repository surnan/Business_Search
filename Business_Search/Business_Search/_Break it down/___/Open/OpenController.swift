//
//  OpenController.swift
//  Business_Search
//
//  Created by admin on 7/29/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData


protocol OpenControllerDelegate {
    var getLatitude: Double {get}
    var getLongitude: Double {get}
}


class OpenController: UIViewController, UITableViewDelegate, UISearchBarDelegate, UISearchResultsUpdating, DataSourceParent, UnBlurViewProtocol, OpenControllerDelegate{
    var currentLocationID   : NSManagedObjectID?                               //Connects downloaded Business to Location
    var doesLocationEntityExist = false                                     //true after create/find location
    var urlsQueue               = [CreateYelpURLDuringLoopingStruct]()      //enumeration loop for semaphores
    var moc                     : NSManagedObjectContext!                 //Parent-Context
    var privateMoc              : NSManagedObjectContext!                 //Child-Context for CoreData Concurrency
    var dataController          : DataController!{                        //MARK: Injected
        didSet {
            moc                 = dataController.viewContext
            privateMoc          = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            privateMoc.parent   = moc
        }
    }
    
    var coordinator             : OpenCoordinator?
    var businessViewModel       : BusinessViewModel!
    var categoryCountViewModel  : CategoryCountViewModel!
    var favoritesViewModel      : FavoritesViewModel!
    var locationViewModel       : LocationViewModel!
    
    var viewObject              : OpenView!
    var latitude                : Double!
    var longitude               : Double!
    var getLatitude             : Double {return latitude}
    var getLongitude            : Double  {return longitude}
    var tableViewArrayType      : Int { return searchGroupIndex }
    enum TableIndex             : Int { case business = 0, category }
    var searchGroupIndex        = 0
    
    

    lazy var tableDataSource    = Open_DataSource(parent: self)
    lazy var tableDelegate      = Open_Delegate(parent: self, source: tableDataSource)
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CategoryCell.self, forCellReuseIdentifier: categoryCellID)
        tableView.register(BusinessCell.self, forCellReuseIdentifier: businessCellID)
        tableView.rowHeight = 70
        tableView.separatorColor = UIColor.clear
        return tableView
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {return .lightContent}
    @objc func handleRightBarButton(){print("")}
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.scopeButtonTitles = ["Business", "Category"]
        searchController.obscuresBackgroundDuringPresentation = false
        //searchController.searchBar.barStyle = .black
        searchController.searchBar.tintColor    = UIColor.white
        searchController.searchBar.barTintColor = UIColor.white
        searchController.searchBar.placeholder  = "Enter search term ..."
        searchController.searchBar.delegate     = self
        searchController.searchResultsUpdater   = self
        //Setting background for search controller
        if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            if let backgroundview = textfield.subviews.first {
                backgroundview.backgroundColor      = UIColor.white
                backgroundview.layer.cornerRadius   = 10
                backgroundview.clipsToBounds = true
            }
        }
        return searchController
    }()
}
