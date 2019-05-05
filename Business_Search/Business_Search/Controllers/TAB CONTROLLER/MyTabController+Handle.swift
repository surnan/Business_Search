//
//  MyTabController+Extension.swift
//  Business_Search
//
//  Created by admin on 4/19/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit



extension MyTabController {
    
    func handlegetNearbyBusinesses(result: Result<YelpBusinessResponse, NetworkError>){
        switch result {
        case .failure(let error):
            print("-->Error: \(error)")
        case .success(let data):
            print("--->handleGetNearbyBusiness below:")
            data.businesses.forEach{
                print($0.name ?? "", $0.display_phone ?? "")
            }
        }
    }
}
