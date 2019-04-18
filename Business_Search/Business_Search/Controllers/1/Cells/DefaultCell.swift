//
//  DefaultCell.swift
//  Business_Search
//
//  Created by admin on 4/17/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class DefaultCell: UITableViewCell {
    
    var name: String? {
        didSet {
            myLabel.text = name
        }
    }
    
    let myLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        [myLabel].forEach{addSubview($0)}
        myLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        myLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
