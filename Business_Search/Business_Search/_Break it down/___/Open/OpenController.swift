//
//  OpenController.swift
//  Business_Search
//
//  Created by admin on 7/29/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

//class OpenController: UIViewController, UITableViewDelegate, UISearchBarDelegate, UISearchResultsUpdating, DataSourceParent {
class OpenController: UIViewController, UISearchBarDelegate, UISearchResultsUpdating, DataSourceParent {
    var coordinator         : SearchTableCoordinator?
    var businessViewModel   : BusinessViewModel!
    var categoryViewModel   : CategoryViewModel!
    var viewObject          : OpenView!
    var dataController      : DataController!
    var latitude            : Double!
    var longitude           : Double!
    
    var searchGroupIndex    = 0
    var tableViewArrayType  : Int { return searchGroupIndex }
    enum TableIndex         : Int { case business = 0, category }

    lazy var tableDataSource = Open_DataSource(parent: self)
    lazy var tableDelegate = Open_Delegate(parent: self, source: tableDataSource)
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CategoryCell.self, forCellReuseIdentifier: categoryCellID)
        tableView.register(BusinessCell.self, forCellReuseIdentifier: businessCellID)
        tableView.rowHeight = 70
        tableView.separatorColor    = UIColor.clear
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = tableDataSource
        tableView.delegate = tableDelegate
        businessViewModel.fetchBusinessController   = nil
        categoryViewModel.fetchCategoryNames        = nil
        navigationItem.searchController             = searchController
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Pause", style: .done, target: self, action: #selector(handleRightBarButton))
        [tableView, viewObject.nothingFoundView].forEach{view.addSubview($0)}
        viewObject.nothingFoundView.centerToSuperView()
        tableView.fillSafeSuperView()
    }
    
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


extension OpenController {
//    func undoBlur() {
//        removeDarkScreenBlur()
//        navigationController?.setNavigationBarHidden(false, animated: true)
//
//        doesLocationEntityExist = false
//        readOrCreateLocation()
//        animateResultsAreFilteredLabel()
//    }
    
    func animateResultsAreFilteredLabel(){
        if !UserAppliedFilter.shared.isFilterOn {return}
        view.addSubview(viewObject.resultsAreFilteredLabel)
        let safe = view.safeAreaLayoutGuide
        viewObject.resultsAreFilteredLabel.anchor(top: safe.topAnchor, leading: safe.leadingAnchor, trailing: safe.trailingAnchor)
        viewObject.resultsAreFilteredLabel.alpha = 1
        UIView.animate(withDuration: 1.5, animations: {
            self.viewObject.resultsAreFilteredLabel.alpha = 0
        }) { (_) in
            self.viewObject.resultsAreFilteredLabel.removeFromSuperview()
        }
    }
    
    func showNothingLabel(tableEmpty: Bool){
        if tableEmpty && searchController.isActive && !searchBarIsEmpty(){
            viewObject.showNothingFoundView()
        } else {
            viewObject.hideNothingFoundView()
        }
    }
}
