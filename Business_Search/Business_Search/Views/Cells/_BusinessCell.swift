//
//  _BusinessCell.swift
//  Business_Search
//
//  Created by admin on 5/4/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit



class _BusinessCell: UITableViewCell {
    var currentBusiness: Business? {
        didSet {
            if let displayAddresses = currentBusiness?.displayAddress,
                let addresse = displayAddresses.split(separator: "?").first,
                let name = currentBusiness?.name {
                let tempString = name + "\n" + addresse
                myLabel.text = tempString
            }
        }
    }
            
    
    let myLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = -1
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(myLabel)
        myLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        myLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/*
class _BusinessCell: UITableViewCell {
    var currentBusiness: Business? {
        didSet {
            if let displayAddresses = currentBusiness?.displayAddress,
                let addresse = displayAddresses.split(separator: "?").first {
                addressLabel.text =  String(addresse)
            }
            
            if let name = currentBusiness?.name {
                nameLabel.text =  name
            }
            
            if let price = currentBusiness?.price {
                priceLabel.text =  price
            }
        }
    }
    
    let yelpImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "question_mark")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "UNKNOWN"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.italicSystemFont(ofSize: 13)
        label.textColor = .darkGray
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        return label
    }()
    
    
    let verticalStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        return stack
    }()
    
    let horizontalStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 3
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        [nameLabel, addressLabel].forEach{verticalStackView.addArrangedSubview($0)}
        [yelpImageView, verticalStackView].forEach{horizontalStackView.addArrangedSubview($0)}
        addSubview(horizontalStackView)
        horizontalStackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        horizontalStackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        horizontalStackView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.75).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
*/
