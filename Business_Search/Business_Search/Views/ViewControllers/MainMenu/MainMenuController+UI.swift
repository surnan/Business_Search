//
//  MainMenuController+UI.swift
//  Business_Search
//
//  Created by admin on 7/22/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreLocation

extension MainMenuController{
    func setupNavigationMenu(){
        let titleImage: UIImageView = {
            let imageView           = UIImageView(image: #imageLiteral(resourceName: "BUSINESS_Finder"))
            imageView.contentMode   = .scaleAspectFit
            return imageView
        }()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "settings"), style: .done, target: self, action: #selector(handleSettings))
        self.navigationItem.titleView = titleImage
    }
    
    func setupUI(){
        setupNavigationMenu()
        let verticalStackView = GenericStack(spacing: 20, distribution: .fillEqually)
        [nearMeSearchButton, searchByMapButton, searchByAddressButton].forEach{verticalStackView.addArrangedSubview($0)}
        view.addSubview(verticalStackView)
        NSLayoutConstraint.activate([
            verticalStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25),
            verticalStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            verticalStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            ])
    }
    
    func undoBlur() {
        removeDarkScreenBlur()
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
