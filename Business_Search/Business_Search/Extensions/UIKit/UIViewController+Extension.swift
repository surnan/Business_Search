//
//  UIViewController+Extension.swift
//  __Virtual_Tourist
//
//  Created by admin on 4/14/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

let blurringScreenDark: UIVisualEffectView = {
    let blurEffect = UIBlurEffect(style: .dark)
    let blur = UIVisualEffectView(effect: blurEffect)
    return blur
}()




let greyPassThroughSuperView: UIView = {
    let _view = UIView()
    _view.backgroundColor = UIColor.grey196Half
    _view.isUserInteractionEnabled = false
    _view.translatesAutoresizingMaskIntoConstraints = false
    return _view
}()

let greyNONPassThroughSuperView: UIView = {
    let _view = UIView()
    _view.backgroundColor = UIColor.grey196Half
    _view.isUserInteractionEnabled = true
    _view.translatesAutoresizingMaskIntoConstraints = false
    return _view
}()


var myActivityMonitor: UIActivityIndicatorView = {
    let activity = UIActivityIndicatorView()
    activity.hidesWhenStopped = true
    activity.style = .whiteLarge
    activity.translatesAutoresizingMaskIntoConstraints = false
    return activity
}()


extension UIViewController {
    func addDarkScreenBlur(){
        navigationController?.setNavigationBarHidden(true, animated: true)
        view.addSubview(blurringScreenDark)
        blurringScreenDark.fillSuperview()
    }
    
    func removeDarkScreenBlur(){
        blurringScreenDark.removeFromSuperview()
    }
    
    
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
    
    
    func showPassThroughNetworkActivityView() {
        [greyPassThroughSuperView, myActivityMonitor].forEach{view.addSubview($0)}
        greyPassThroughSuperView.fillSuperview()
        myActivityMonitor.centerToSuperView()
        myActivityMonitor.startAnimating()
    }
    
    
    func showNONPassThroughNetworkActivityView() {
        [greyNONPassThroughSuperView, myActivityMonitor].forEach{view.addSubview($0)}
        greyNONPassThroughSuperView.fillSuperview()
        myActivityMonitor.centerToSuperView()
        myActivityMonitor.startAnimating()
    }
    
    func showFinishNetworkRequest(){
        greyPassThroughSuperView.removeFromSuperview()
        greyNONPassThroughSuperView.removeFromSuperview()
        myActivityMonitor.stopAnimating()
    }
}

extension UIViewController: Presentable {
    func toPresentable() -> UIViewController {
        return self
    }
}

