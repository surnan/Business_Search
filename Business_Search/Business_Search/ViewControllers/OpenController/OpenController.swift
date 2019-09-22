//
//  OpenController.swift
//  Business_Search
//
//  Created by admin on 7/29/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData
import Lottie

class OpenController: UIViewController, UITableViewDelegate, UISearchBarDelegate, UISearchResultsUpdating, DataSourceType, UnBlurViewType, OpenControllerType{
    var animationView           = LOTAnimationView()
    
    var currentLocationID       : NSManagedObjectID?                      //Connects downloaded Business to Location
    var doesLocationEntityExist = false                                   //true after create/find location
    var urlsQueue               = [CreateYelpURLDuringLoopingStruct]()    //enumeration loop for semaphores
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
    private var latitude        : Double
    private var longitude       : Double
    var getLatitude             : Double {return latitude}
    var getLongitude            : Double  {return longitude}
    var tableViewArrayType      : Int { return searchGroupIndex }
    enum TableIndex             : Int { case business = 0, category }
    var searchGroupIndex        = 0
    
    init(lat: Double, lon: Double) {
        self.latitude           = lat
        self.longitude          = lon
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {fatalError("init(coder:) has not been implemented")}

    lazy var tableDataSource    = Open_DataSource(parent: self)
    lazy var tableDelegate      = Open_Delegate(parent: self, source: tableDataSource)
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CategoryCell.self, forCellReuseIdentifier: categoryCellID)
        tableView.register(BusinessCell.self, forCellReuseIdentifier: businessCellID)
        tableView.rowHeight = 70
        tableView.separatorColor = UIColor.clear
        tableView.keyboardDismissMode = UIScrollView.KeyboardDismissMode.onDrag
        return tableView
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {return .lightContent}

    func updateCoordinate(lat: Double, lon: Double){
        self.latitude = lat
        self.longitude = lon
    }
    
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.scopeButtonTitles = ["Business", "Category"]
        searchController.searchBar.placeholder = "Enter name ..."
        searchController.searchBar.tintColor = .white
        searchController.searchBar.searchBarStyle = .minimal
        let differentColorSearchBar = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 36))
        differentColorSearchBar.layer.cornerRadius = 5
        differentColorSearchBar.clipsToBounds = true
        differentColorSearchBar.backgroundColor = UIColor.white
        searchController.searchBar.setSearchFieldBackgroundImage(differentColorSearchBar.asImage(), for: .normal)
        definesPresentationContext = true
        searchController.searchBar.delegate     = self
        searchController.searchResultsUpdater   = self
        return searchController
    }()
}





extension UIView {
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

