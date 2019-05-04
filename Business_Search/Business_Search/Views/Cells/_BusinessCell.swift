//
//  _BusinessCell.swift
//  Business_Search
//
//  Created by admin on 5/4/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class _BusinessCell: UITableViewCell {
    var currentBusiness: Business!
    
    let yelpImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    let phoneNumberLabel: UILabel = {
    let label = UILabel()
        label.font = UIFont(name: "Georgia", size: 12)
       return label
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
