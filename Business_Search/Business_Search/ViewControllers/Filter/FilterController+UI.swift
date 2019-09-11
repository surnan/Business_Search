//
//  FilterController+UI.swift
//  Business_Search
//
//  Created by admin on 7/28/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit


extension FilterController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isFilteredLabel.isHidden = !UserAppliedFilter.shared.isFilterOn
    }
    
    func setupUI(){
        
        /*
        let lineView = UIView()
        //lineView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        lineView.backgroundColor = UIColor.white
        lineView.translatesAutoresizingMaskIntoConstraints = false
        */
        
        let fullStackView   = viewObject.getFullStack()
        view.addSubview(fullStackView)
//        view.addSubview(lineView)

    
        
        fullStackView.centerToSuperView()
        fullStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75).isActive = true
        
        view.addSubview(isFilteredLabel)
        
        let safe = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            isFilteredLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            isFilteredLabel.topAnchor.constraint(equalTo: safe.topAnchor, constant: 10),
            isFilteredLabel.widthAnchor.constraint(equalTo: safe.widthAnchor),
            
//            lineView.topAnchor.constraint(equalTo: isFilteredLabel.bottomAnchor, constant: 5),
//            lineView.widthAnchor.constraint(equalTo: fullStackView.widthAnchor),
//            lineView.heightAnchor.constraint(equalToConstant: 0.5),
//            lineView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
    }
}


/*
func setupUI(){
    
    //
    let lineView = UIView()
    //lineView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
    lineView.backgroundColor = UIColor.white
    lineView.translatesAutoresizingMaskIntoConstraints = false
    //
    
    let fullStackView   = viewObject.getFullStack()
    view.addSubview(fullStackView)
    view.addSubview(lineView)
    
    
    
    fullStackView.centerToSuperView()
    fullStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75).isActive = true
    
    view.addSubview(isFilteredLabel)
    
    let safe = view.safeAreaLayoutGuide
    
    NSLayoutConstraint.activate([
        isFilteredLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        isFilteredLabel.topAnchor.constraint(equalTo: safe.topAnchor, constant: 10),
        isFilteredLabel.widthAnchor.constraint(equalTo: safe.widthAnchor),
        
        lineView.topAnchor.constraint(equalTo: isFilteredLabel.bottomAnchor, constant: 5),
        lineView.widthAnchor.constraint(equalTo: fullStackView.widthAnchor),
        lineView.heightAnchor.constraint(equalToConstant: 0.5),
        lineView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
}
*/
