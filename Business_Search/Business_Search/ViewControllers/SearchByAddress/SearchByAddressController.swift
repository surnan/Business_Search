//
//  SearchByAddressController.swift
//  Business_Search
//
//  Created by admin on 5/5/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit


class SearchByAddressController: UIViewController, UITextViewDelegate, UITextFieldDelegate, MKMapViewDelegate, UIGestureRecognizerDelegate {
    var coordinator             : SearchTableType?
    var viewObject              : SearchByAddressView!
    var viewModel               : SearchByAddressViewModel!
    
    let geoCoder                = CLGeocoder()
    var locationToForward       = CLLocation()                //Pushing into newController()
    lazy var mapView            = viewObject.mapView
    lazy var locationImageView  = viewObject.locationImageView
    lazy var locationTextField  = viewObject.locationTextField
    lazy var findLocationButton = viewObject.findLocationButton
    
    let textViewMaxHeight: CGFloat = 50
    
//    var myTextView: UITextView = {
//        let textView = UITextView()
//        textView.text = "Placeholder..."
//        textView.font = UIFont(name: "Georgie", size: 25)
//        textView.textColor = .lightGray
//        textView.sizeToFit()
//        textView.isScrollEnabled = false
//        textView.translatesAutoresizingMaskIntoConstraints = false
//        return textView
//    }()
    
    lazy var myTextView = viewObject.myTextView
    
    
    enum ButtonState {
        case disabled, find, next
    }
    
    var barButtonState = ButtonState.disabled
    
    var found = false
}




extension SearchByAddressController {
    
    func textViewDidChange(_ textView: UITextView) {
        let fixedWidth = myTextView.frame.size.width
        let newSize: CGSize = myTextView.sizeThatFits(CGSize(width: fixedWidth, height: textViewMaxHeight))
        var newFrame = myTextView.frame
        newFrame.size = CGSize(width: newSize.width, height: newSize.height)
        
        
        if found {return}
        if textView.text.isEmpty {
            setRightBarButton(state: .disabled)
        } else {
            setRightBarButton(state: .find)
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
}
