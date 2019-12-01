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
        self.title = "" //Removes the "Back" from navigation menu
        setupUI()       //Error if it's in ViewDidLoad & it resets MenuBarButton
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addHandlers()
        [nearMeButton, byMapButton, byAddressButton].forEach{
            view.addSubview($0)
            $0.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
            $0.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            $0.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.66).isActive = true
        }
    }
    
    
    private func deleteLocationsIfInvalid(){
        viewModel.resetToday()
        viewModel.changeDate()
        let today = Date()
        if !viewModel.doesDateMatch(date: today) {
            locationViewModel.deleteAllLocations()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //[locationViewModel, viewModel] = NIL @ viewWillApear, viewDidLoad
        //deleteLocationsIfInvalid()
        setupUI()
    }
    
    func undoBlur() {
        removeDarkScreenBlur()
        navigationController?.setNavigationBarHidden(false, animated: true)
        setupUI()
    }
    
    func setupUI(){
        let settingsBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "settings"),
                                                style: .done,
                                                target: self,
                                                action: #selector(handleSettings))

        let filterButton = getFilterButton(target: self, selector: #selector(handleFilter))
        
        navigationItem.rightBarButtonItems = [settingsBarButton, filterButton]
        
        self.navigationItem.titleView = mainView.titleImage
        let safe = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            byMapButton.centerYAnchor.constraint(equalTo: safe.centerYAnchor, constant: -20),
            nearMeButton.bottomAnchor.constraint(equalTo: byMapButton.topAnchor, constant: -20),
            byAddressButton.topAnchor.constraint(equalTo: byMapButton.bottomAnchor, constant: 20)
            ])
    }
}
