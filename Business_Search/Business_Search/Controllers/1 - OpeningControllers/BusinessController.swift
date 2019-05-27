//
//  BusinessController.swift
//  Business_Search
//
//  Created by admin on 5/10/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData
import MapKit


class BusinessController: UIViewController {
    
    var business: Business! {
        didSet {
            if let name = business.name {
                let attributes: [NSAttributedString.Key: Any] = [
                    .foregroundColor : UIColor.black,
                    .font: UIFont.boldSystemFont(ofSize: 28),
                ]
                nameLabel.attributedText = NSAttributedString(string: name, attributes: attributes)
                nameLabel.textAlignment = .center
            }
            
            if let address = business.displayAddress {
                let replaced = address.replacingOccurrences(of: "?", with: "\n")
                let attributes: [NSAttributedString.Key: Any] = [
                    .foregroundColor : UIColor.black,
                    .font: UIFont(name: "Georgia", size: 25) as Any,
                ]
                addressLabel.attributedText = NSAttributedString(string: replaced, attributes: attributes)
                addressLabel.textAlignment = .center
            }
            
            
            if let phoneNumber = business.displayPhone {
                let phoneText = "tel://\(phoneNumber)"
                let attributes: [NSAttributedString.Key: Any] = [
                    .foregroundColor : UIColor.blue,
                    .font: UIFont(name: "Arial", size: 25) as Any,
                    // NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
                ]
                phoneNumberLabel.attributedText = NSAttributedString(string: phoneText, attributes: attributes)
                phoneNumberLabel.textAlignment = .center
            }
            
            if let phoneNumber = business.displayPhone {
                let phoneText = "\(phoneNumber)"
                let attributes: [NSAttributedString.Key: Any] = [
                    .foregroundColor : UIColor.blue,
                    .font: UIFont(name: "Georgia", size: 25) as Any,
                ]
                
                let myNormalAttributedTitle = NSAttributedString(string: phoneText,
                                                                 attributes: attributes)
                phoneNumberButton.setAttributedTitle(myNormalAttributedTitle, for: .normal)
            }
            
            
            
            if let price = business.price {
                let text = "Price: \(price)"
                priceLabel.attributedText = NSAttributedString(string: text, attributes: black25textAttributes)
                priceLabel.textAlignment = .center
            }
            
            let ratingText = "Rating: \(business.rating)"
            ratingLabel.attributedText = NSAttributedString(string: ratingText, attributes: black25textAttributes)
            ratingLabel.textAlignment = .center
        }
    }
    
    @objc func handlePhoneButton(){
        print("Button Pressed")
    }
    
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var addressLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        return label
    }()
    
    var ratingLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    var priceLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    var websiteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Load Website from Yelp", for: .normal)
        return button
    }()
    
    var phoneNumberLabel: UILabel = {
        let label = UILabel()
        let text = ""
        label.attributedText = NSAttributedString(string: text, attributes: black25textAttributes)
        label.textAlignment = .center
        return label
    }()
    
    var phoneNumberButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(phoneTapped(sender:)), for: .touchUpInside)
        return button
    }()
    
    lazy var visitYelpPageButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 12
        let attributedString = NSAttributedString(string: "Visit Yelp Page", attributes: white25textAttributes)
        button.setAttributedTitle(attributedString, for: .normal)
        button.backgroundColor = UIColor.blue
        button.addTarget(self, action: #selector(handleVisitYelpPageButton(_:)), for: .touchUpInside)
        return button
    }()
    
    @objc func handleVisitYelpPageButton(_ sender: UIButton){
        guard var _stringToURL = business.url else {
            UIApplication.shared.open(URL(string: "https://www.yelp.com")!)     //MediaURL = empty, load Yelp
            return
        }
        let backupURL = URL(string: "https://www.yelp.com")!  //URL is invalid, convert string to google search query
        if _stringToURL._isValidURL {
            _stringToURL = _stringToURL._prependHTTPifNeeded()
            let url = URL(string: _stringToURL) ?? backupURL
            UIApplication.shared.open(url)
        } else {
            UIApplication.shared.open(backupURL)
        }
    }
    
    
    lazy var mapItButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 12
        let attributedString = NSAttributedString(string: "     MAP IT     ", attributes: white25textAttributes)
        button.setAttributedTitle(attributedString, for: .normal)
        button.backgroundColor = UIColor.red
        button.addTarget(self, action: #selector(handlemapItButton(_:)), for: .touchUpInside)
        return button
    }()
    
    
    @objc func handlemapItButton(_ sender: UIButton){
        let newVC = GoToMapController()
        newVC.business = business
        navigationController?.pushViewController(newVC, animated: true)
    }
    
    
    
    var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.white
        [addressLabel, phoneNumberButton, priceLabel, ratingLabel, visitYelpPageButton, mapItButton ].forEach{stackView.addArrangedSubview($0)}
        [nameLabel, stackView].forEach{view.addSubview($0)}
        nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25).isActive = true
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 15).isActive = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "pause", style: .done, target: self, action: #selector(pauseFunc))
    }
    
    
    @objc func phoneTapped(sender: UIButton){
        print("phone tapped")
        print("title = \(sender.titleLabel?.text ?? "")")
        guard let numberString = sender.titleLabel?.text else {return}
        let number = numberString.filter("0123456789".contains)
        let call = number
        print("call --> \(call)")
        if let url = URL(string: "tel://\(call)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    @objc func pauseFunc(){
        print("")
    }
}


extension String {
    var _isValidURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let range = NSRange(startIndex..., in: self)    //startIndex = position of first character in non-empty String
        return detector.firstMatch(in: self, range: range)?.range == range
    }
    
    func _prependHTTPifNeeded() -> String{
        if prefix(4) != "http" {
            return "http://" + self
        } else {
            return self
        }
    }
}
