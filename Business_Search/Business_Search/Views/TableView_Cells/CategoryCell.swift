//
//  DefaultCell.swift
//  Business_Search
//
//  Created by admin on 4/17/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {
    
    var firstViewModel: MyCategoryViewModel! {
        didSet{
            myLabel.text = firstViewModel.name
            backColor = firstViewModel.originalColor
            let count = firstViewModel.count ?? 0
            let matches = count > 1 ? "matches" : "match"
            countLabel.text = "\(count) \(matches)\nfound"
        }
    }

    var backColor: UIColor!
    
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        [myLabel, countLabel].forEach{addSubview($0)}
        NSLayoutConstraint.activate([
            countLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            countLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            myLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            myLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            myLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        if isHighlighted {
            //contentView.backgroundColor = .darkBlue
            backgroundColor = .darkBlue
            myLabel.textColor = .white
        } else {
            myLabel.textColor = .black
            backgroundColor = backColor
        }
    }
}
