//
//  FavoriteBusinessCell.swift
//  Business_Search
//
//  Created by admin on 6/8/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit


class FavoriteBusinessCell: UITableViewCell {
    var favoriteBusiness: FavoriteBusiness? {
        didSet {
            guard let business = favoriteBusiness else { return }
            if let displayAddresses = business.displayAddress,
                let addresse = displayAddresses.split(separator: "?").first,
                let name = business.name {
                let nameNewLine = "\(name)\n"
                let stringOne = NSMutableAttributedString(string: nameNewLine, attributes: attributes1)
                let stringTwo = NSMutableAttributedString(string: String(addresse), attributes: attributes2)
                stringOne.append(stringTwo)
                myLabel.attributedText = stringOne
            }
            yelpImageView.image = business.isFavorite ? #imageLiteral(resourceName: "Favorite") : #imageLiteral(resourceName: "UnFavorite")
        }
    }
    
    let yelpImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "UnFavorite")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let myLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = -1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        [yelpImageView, myLabel].forEach{addSubview($0)}
        yelpImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        yelpImageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        yelpImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.85).isActive = true
        myLabel.leadingAnchor.constraint(equalTo: yelpImageView.trailingAnchor, constant: 1).isActive = true
        myLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        myLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
