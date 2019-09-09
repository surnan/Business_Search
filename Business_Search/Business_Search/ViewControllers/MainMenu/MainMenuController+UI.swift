//
//  MainMenuController+UI.swift
//  Business_Search
//
//  Created by admin on 7/28/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

extension MainMenuController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor    = .white
        coordinateFound         = false
        previousCoordinate      = nil
        setupUI()   //Error if it's in ViewDidLoad & it resets MenuBarButton
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addHandlers()
        
        

        //[stack].forEach{view.addSubview($0)}
        [nearMeButton, byMapButton, byAddressButton].forEach{
            view.addSubview($0)
            $0.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
            $0.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            $0.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.66).isActive = true
        }
    }
    
    func undoBlur() {
        removeDarkScreenBlur()
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func setupUI(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "settings"), style: .done, target: self, action: #selector(handleSettings))
        self.navigationItem.titleView = mainView.titleImage
        
        let safe = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            byMapButton.centerYAnchor.constraint(equalTo: safe.centerYAnchor, constant: -20),
            nearMeButton.bottomAnchor.constraint(equalTo: byMapButton.topAnchor, constant: -20),
            byAddressButton.topAnchor.constraint(equalTo: byMapButton.bottomAnchor, constant: 20)
            ])
    }
}
