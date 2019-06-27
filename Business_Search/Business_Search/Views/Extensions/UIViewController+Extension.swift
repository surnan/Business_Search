//
//  UIViewController+Extension.swift
//  __Virtual_Tourist
//
//  Created by admin on 4/14/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

extension UIViewController {    
    func showAlertController(title: String, message: String, okFunction: ((UIAlertAction) -> Void)? = nil) {
        let myAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        myAlertController.addAction(UIAlertAction(title: "OK", style: .default, handler: okFunction))
        if let _ = okFunction {
            myAlertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        }
        present(myAlertController, animated: true)
    }
    
    func showOKAlertController(title: String, message: String){
        let myAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        myAlertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(myAlertController, animated: true)
    }
    
    func showOKCancelAlertController(title: String, message: String, okFunction: ((UIAlertAction) -> Void)?) {
        let myAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        myAlertController.addAction(UIAlertAction(title: "OK", style: .default, handler: okFunction))
        myAlertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        present(myAlertController, animated: true)
    }
}
