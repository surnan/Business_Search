//
//  MenuController.swift
//  Business_Search
//
//  Created by admin on 5/5/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData


class MenuController: UIViewController {
    
    var dataController: DataController!  //MARK: Injected
    
    
    var nearMeSearchButton: UIButton = {
        let button = UIButton()
        button.setTitle("Search near me", for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(handleNearMeSearchButton), for: .touchUpInside)
        return button
    }()
    
    var overThereSearchButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitle("     Specify a search location     ", for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(handleOverThereSearchButton), for: .touchUpInside)
        return button
    }()
    
    
    var nonDistanceSearchButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .purple
        button.setTitle("Search all categories", for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(handleNonDistanceSearchButton), for: .touchUpInside)
        return button
    }()
    
    var verticalStackView: UIStackView = {
       let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        [nearMeSearchButton, overThereSearchButton, nonDistanceSearchButton].forEach{verticalStackView.addArrangedSubview($0)}
        [verticalStackView].forEach{view.addSubview($0)}
        
        NSLayoutConstraint.activate([
            verticalStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25),
            verticalStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            verticalStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
        ])
    }
    
    
    @objc func handleNearMeSearchButton(){
        let newVC = OpeningController()
        newVC.dataController = dataController
        navigationController?.pushViewController(newVC, animated: true)
    }
    
    @objc func handleOverThereSearchButton(){
        let newVC = OpeningController()
        newVC.dataController = dataController
        navigationController?.pushViewController(newVC, animated: true)
    }
    
    @objc func handleNonDistanceSearchButton(){
        print("")
    }
}

