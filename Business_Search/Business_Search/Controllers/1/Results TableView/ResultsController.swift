//
//  FirstController+TableView.swift
//  Business_Search
//
//  Created by admin on 4/16/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
let defaultCellID = "defaultCellID"

protocol TestProtocol {
    var getNameTitle: String {get}
    var getIdAlias: String   {get}
}

struct BusinessesStructForArray: Codable, TestProtocol{
    var id: String
    var name: String
    var getNameTitle: String {return name}
    var getIdAlias: String {return id}
}

struct CategoriesStructForArray: Codable, TestProtocol{
    var alias: String
    var title: String
    var getNameTitle: String {return title}
    var getIdAlias: String {return alias}
}

enum IndexOf: Int, CaseIterable {
    case business = 0
    case categories = 1
}


protocol ResultsControllerDelegate {
    func refreshCollectionView()
}

class ResultsController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate, ResultsControllerDelegate {
    
    func refreshCollectionView() {
        print("")
    }
    
    var tableViewArray = [[TestProtocol]]()
    var indexValue = 0
    var inputString = ""
    var urlSessionTask: URLSessionDataTask?

    
    override func viewDidLoad() {
        IndexOf.allCases.forEach{_ in tableViewArray.append( [TestProtocol]())}
        tableView.register(DefaultCell.self, forCellReuseIdentifier: defaultCellID)
        tableView.backgroundColor = UIColor.lightBlue
    }
}
