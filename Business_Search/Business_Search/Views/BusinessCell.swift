//
//  _BusinessCell.swift
//  Business_Search
//
//  Created by admin on 5/4/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {
    var firstViewModel: BusinessCellViewModel! {
        didSet {
            myLabel.attributedText = firstViewModel.getMyLabelAttributedString
            yelpImageView.image = firstViewModel.getFavoriteImage
            backColor = firstViewModel.getOriginalColor
            accessoryType = firstViewModel.getAccessoryType
        }
    }
    
    var backColor: UIColor!
    
    private let yelpImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "UnFavorite")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let myLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = -1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        [yelpImageView, myLabel].forEach{addSubview($0)}

        NSLayoutConstraint.activate([
            yelpImageView.centerYAnchor.constraint  (equalTo: centerYAnchor),
            yelpImageView.leadingAnchor.constraint  (equalTo: leadingAnchor),
            yelpImageView.heightAnchor.constraint   (equalTo: heightAnchor, multiplier: 0.85),
            
            myLabel.leadingAnchor.constraint        (equalTo: yelpImageView.trailingAnchor, constant: 1),
            myLabel.centerYAnchor.constraint        (equalTo: centerYAnchor),
            myLabel.trailingAnchor.constraint       (equalTo: trailingAnchor, constant: -5)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        if isHighlighted {
            contentView.backgroundColor = .lightRed
            backgroundColor = .lightRed
            myLabel.textColor = .white
        } else {
            myLabel.textColor = .black
            backgroundColor = backColor
            contentView.backgroundColor = backColor
        }
    }
}

