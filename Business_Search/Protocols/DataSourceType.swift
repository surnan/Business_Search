//
//  DataSourceParent.swift
//  Business_Search
//
//  Created by admin on 8/1/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

protocol DataSourceType {
    var businessViewModel   : BusinessViewModel! {get}
    var categoryCountViewModel   : CategoryCountViewModel! {get}
    var getLatitude: Double {get}
    var getLongitude: Double {get}
    var dataController      : DataController! {get}
    var tableViewArrayType  : Int {get}
    func showNothingLabel(tableEmpty: Bool)
}
