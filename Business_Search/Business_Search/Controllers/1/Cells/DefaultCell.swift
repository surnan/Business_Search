//
//  DefaultCell.swift
//  Business_Search
//
//  Created by admin on 4/17/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class DefaultCell: UITableViewCell {
    
    let myLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello World"
        label.textColor = UIColor.black
        label.backgroundColor = UIColor.yellow
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        [myLabel].forEach{addSubview($0)}
        myLabel.fillSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
