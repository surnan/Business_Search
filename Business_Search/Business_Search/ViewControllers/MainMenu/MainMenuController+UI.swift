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
        [stack].forEach{view.addSubview($0)}
    }
    
    func undoBlur() {
        removeDarkScreenBlur()
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func setupUI(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "settings"), style: .done, target: self, action: #selector(handleSettings))
        self.navigationItem.titleView = mainView.titleImage
        NSLayoutConstraint.activate([
            stack.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25),
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            ])
    }
}
