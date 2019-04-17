//
//  ViewController.swift
//  Business_Search
//
//  Created by admin on 4/14/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import MapKit

class MapController: UITabBarController {
    var fullScreenMap = MKMapView()
    
    
    func setupUI(){
        [fullScreenMap].forEach{view.addSubview($0)}
        fullScreenMap.fillSafeSuperView()
    }
    
    
    struct categoriesStruct: Codable {
        var alias: String
        var title: String
    }
    
    struct YelpStruct: Codable {
        var categories: [categoriesStruct]
        var businesses: [String]
        var terms: [[String: String]]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        let url = URL(string: "https://api.yelp.com/v3/autocomplete?text=del&latitude=37.786882&longitude=-122.399972")!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(API_Key)", forHTTPHeaderField: "Authorization")

        
        URLSession.shared.dataTask(with: request){ (data, resp, err) in
            if let err = err {print("error:\n\(err)")}
            guard let dataObject =  data else {print("There's no data"); return}

            do {
                let answer = try JSONDecoder().decode(YelpStruct.self, from: dataObject)
                print("answer:\n\(answer)")
            } catch {
                print("failed: \n\(error)")
            }
        }.resume()
    }
}

