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
    

    
    var barButtonState = ButtonState.disabled
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        locationTextField.delegate = self
        myTextView.delegate = self
        setupUI()
        addHandlers()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //barButtonState = ButtonState.disabled
    }
    
    
    let textViewMaxHeight: CGFloat = 50
    
    var myTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Placeholder..."
        textView.textColor = .lightGray
        textView.sizeToFit()
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    enum ButtonState: String {
        case disabled, find, next
    }
}

extension SearchByAddressController {
    func textViewDidChange(_ textView: UITextView) {
        if textView.contentSize.height >= self.textViewMaxHeight
        {
            textView.isScrollEnabled = true
            textView.frame.size.height = textView.contentSize.height
        }
        else
        {
            textView.frame.size.height = textView.contentSize.height
            textView.isScrollEnabled = false
        }
    }
    
    
//    func textViewDidChangeSelection(_ textView: UITextView) {
//        if self.view.window != nil {
//            if textView.textColor == UIColor.lightGray {
//                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
//            }
//        }
//    }
  
    
    func textViewDidBeginEditing(_ textView: UITextView) {
                if textView.textColor == UIColor.lightGray {
                    textView.text = nil
                    textView.textColor = UIColor.black
                }
    }    
}
