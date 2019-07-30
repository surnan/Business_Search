//
//  Open_Delegate.swift
//  Business_Search
//
//  Created by admin on 7/30/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class Open_Delegate: NSObject, UITableViewDelegate {
    var parent: OpenController
    var source: UITableViewDataSource
    
    init(parent: OpenController, source: UITableViewDataSource) {
        self.parent = parent
        self.source = source
    }

    
    
}
