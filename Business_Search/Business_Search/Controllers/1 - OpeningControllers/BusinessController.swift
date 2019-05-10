//
//  BusinessController.swift
//  Business_Search
//
//  Created by admin on 5/10/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData
import MapKit


class BusinessController: UIViewController {
    
    var business: Business! {
        didSet {
            if let name = business.name { nameLabel.text = "Name: \(name)" }
            if let price = business.price { priceLabel.text = "Price: \(price)" }
            ratingLabel.text = "Rating: \(business.rating)"
            
            if let address = business.displayAddress {
                let replaced = address.replacingOccurrences(of: "?", with: "\n")
                addressLabel.text = replaced
            }
        }
    }
    
    
    var nameLabel: UILabel = {
       let label = UILabel()
        return label
    }()
    
    var addressLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        return label
    }()
    
    var ratingLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    var priceLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    var websiteButton: UIButton = {
       let button = UIButton()
        button.setTitle("Load Website from Yelp", for: .normal)
        return button
    }()
    
    var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.orange
        
        [nameLabel, addressLabel, priceLabel, ratingLabel].forEach{stackView.addArrangedSubview($0)}
        [stackView].forEach{view.addSubview($0)}
        
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        
    }
}
