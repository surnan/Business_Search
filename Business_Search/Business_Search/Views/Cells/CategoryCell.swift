//
//  DefaultCell.swift
//  Business_Search
//
//  Created by admin on 4/17/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {

    var name: String! {
        didSet {
            myLabel.text = name
        }
    }
    
    
    var count: Int! {
        didSet{
            let matches = count > 1 ? "matches" : "match"
            countLabel.text = "\(count ?? 0) \(matches)\nfound"
        }
    }
    
    
    
    let myLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = UIColor.black
        label.numberOfLines = -1
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var countLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 2
        label.textColor = UIColor.darkGray
        label.font = UIFont.italicSystemFont(ofSize: 11)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    var accessoryLabel: UILabel = {
        let label = UILabel()
        label.text = "➣"
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        [accessoryLabel, myLabel, countLabel].forEach{addSubview($0)}
        
        NSLayoutConstraint.activate([
            accessoryLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            accessoryLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            countLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            countLabel.trailingAnchor.constraint(equalTo: accessoryLabel.leadingAnchor, constant: -10),
            
            myLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            myLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            myLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
