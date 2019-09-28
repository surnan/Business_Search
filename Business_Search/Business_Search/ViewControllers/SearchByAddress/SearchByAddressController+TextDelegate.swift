//
//  SearchByAddressController+TextDelegate.swift
//  Business_Search
//
//  Created by admin on 9/25/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit


extension SearchByAddressController {
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        let curretText = textField.text ?? ""
        
        if curretText.isEmpty {
            setRightBarButton(state: .disabled)
        } else {
            setRightBarButton(state: .find)
        }
    }
}










extension SearchByAddressController {
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty || textView.textColor == .lightGray {
            setRightBarButton(state: .disabled)
        } else {
            setRightBarButton(state: .find)
        }
        
        if textView.textColor == .lightGray {
            textView.textColor = .black
        }
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.textColor = UIColor.black
            textView.text = ""
            print("Begin Edit")
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) -> Bool {
        print("END Edit")
        return true
    }
    
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        print("Did Change Selection")
    }
}

