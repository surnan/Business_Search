//
//  SearchByMapController+Handlers.swift
//  Business_Search
//
//  Created by admin on 7/28/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

extension SearchByMapController {
    @objc func handleRightBarButton(){
        coordinator?.loadSearchTable(location: locationToForward)
    }
}
