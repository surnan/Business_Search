//
//  TESTING.swift
//  Business_Search
//
//  Created by admin on 4/24/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

//class TestingStuff: UIViewController {
//    
//    func retry<T>(_ attempts: Int, task: @escaping (_ success: @escaping (T) -> Void, _ failure: @escaping (Error) -> Void) -> Void, success: @escaping (T) -> Void, failure: @escaping (Error) -> Void) {
//        task({ (obj) in
//            success(obj)
//        }) { (error) in
//            print("Error retry left \(attempts)")
//            if attempts > 1 {
//                self.retry(attempts - 1, task: task, success: success, failure: failure)
//            } else {
//                failure(error)
//            }
//        }
//    }
//    
//    
//    NetworkManager.shared.retry(3, task: { updatedUser, failure in
//    NetworkManager.shared.updateUser(user, success: updatedUser, error: failure) }
//    , success: { (updatedUser) in
//    print(updatedUser.debugDescription)
//    }) { (err) in
//    print(err)
//    }
//}
