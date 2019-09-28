//
//  File.swift
//  Business_Search
//
//  Created by admin on 7/16/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class PresentCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var presentingVC: UIViewController
    init(presenting: UIViewController) {self.presentingVC = presenting}
    func start(){fatalError("Children should implement 'start'")}
}

class PresentSettingsCoordinator: PresentCoordinator {
    var dataController: DataController
    
    func present(destination: UIViewController){
        presentingVC.present(destination, animated: true, completion: nil)
    }
    
    init(presenting: UIViewController, dataController: DataController, animated: Bool = true) {
        self.dataController = dataController
        super.init(presenting: presenting)
    }
    
    override func start() {
        let destination = SettingsController()
        destination.dataController = dataController
        destination.delegate = presentingVC as? UnBlurViewProtocol
        destination.modalPresentationStyle = .overFullScreen
        present(destination: destination)
    }
}
