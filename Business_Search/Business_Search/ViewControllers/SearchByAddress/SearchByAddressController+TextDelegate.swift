//
//  SearchByAddressController+TextDelegate.swift
//  Business_Search
//
//  Created by admin on 9/25/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

extension SearchByAddressController {
    
    func textViewDidChange(_ textView: UITextView) {

        
//        textView.text.isEmpty ? setRightBarButton(state: .disabled) : setRightBarButton(state: .find)
        
        if textView.text.isEmpty || textView.textColor == .lightGray {
            setRightBarButton(state: .disabled)
        } else {
            setRightBarButton(state: .find)
        }
        
        
//        if textView.text.isEmpty {
//            setRightBarButton(state: .disabled)
//        } else {
//            setRightBarButton(state: .find)
//        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
}
