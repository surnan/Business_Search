//
//  FilterController.swift
//  Business_Search
//
//  Created by admin on 6/3/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData

class CustomButton: UIButton {
    override open var isHighlighted: Bool {
        didSet {
            backgroundColor = isSelected ? UIColor.white : UIColor.clear
        }
    }
}

class FilterController: UIViewController {
    
    var sliderLabel: UILabel = {
        var label = UILabel()
        label.text = "Minimum Yelp Rating"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var sliderLeftLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var sliderRightLabel: UILabel = {
        let label = UILabel()
        label.text = "5"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var sliderValueLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .blue
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .white
        //label.text = "temp"
        
        let intRadius = Int(radius)
        label.text = "\(intRadius)"
        
        label.text = UserAppliedFilter.shared.getMinimumRating
        
        print("UserAppliedFilter.shared.getMinimumRating = \(UserAppliedFilter.shared.getMinimumRating)")
        
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.textAlignment = .center
        return label
    }()
    
    lazy var distanceSlider: UISlider = {
        var slider = UISlider()
        slider.minimumTrackTintColor = .gray
        slider.maximumTrackTintColor = .black
        slider.minimumValue = 0.0
        slider.maximumValue = 5.0
        
        //UserAppliedFilter.shared.getMinimumRating
        //slider.value = Float(radius)
        
        slider.value = Float(UserAppliedFilter.shared.getMinimumRating) ?? 0.0
        
        slider.thumbTintColor = .white
        slider.isContinuous = true
        slider.addTarget(self, action: #selector(handleSliderValueChange(_:forEvent:)), for: .valueChanged)
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    @objc func handleSliderValueChange(_ sender: UISlider, forEvent event: UIEvent){
        let temp = sender.value.rounded(digits: 1)
        print("Radius ---> \(temp)")
        sliderValueLabel.text = "\(temp)"
    }
    

    
    @objc func handleDollarButtons(_ sender: CustomButton){
        sender.isSelected = !sender.isSelected
    }
    
    @objc func handleSwitch(_ sender: UISwitch){
        //print("sender.isOn --> \(sender.isOn)")
    }
    
    var delegate: MenuControllerDelegate?

    
    lazy var dollarOneButton: CustomButton = {
        let button = CustomButton()
        button.setTitle("$", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.black, for: .selected)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        button.addTarget(self, action: #selector(handleDollarButtons(_:)), for: .touchDown)
        return button
    }()
    
    lazy var dollarTwoButton: CustomButton = {
        let button = CustomButton()
        button.setTitle("$$", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.black, for: .selected)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(handleDollarButtons(_:)), for: .touchDown)
        return button
    }()
    
    lazy var dollarThreeButton: CustomButton = {
        let button = CustomButton()
        button.setTitle("$$$", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.black, for: .selected)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(handleDollarButtons(_:)), for: .touchDown)
        return button
    }()
    
    lazy var dollarFourButton: CustomButton = {
        let button = CustomButton()
        button.setTitle("$$$$", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.black, for: .selected)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        button.addTarget(self, action: #selector(handleDollarButtons(_:)), for: .touchDown)
        return button
    }()
    
    lazy var defaultButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(handleDefaultButton), for: .touchUpInside)
        button.backgroundColor = UIColor.white
        button.setTitle("   Reset to Defaults     ", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(handleSaveButton), for: .touchUpInside)
        button.backgroundColor = UIColor.white
        button.setTitle("     SAVE     ", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(handlecancelButton), for: .touchUpInside)
        button.backgroundColor = UIColor.white
        button.setTitle("     CANCEL     ", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var priceLabel: UILabel = {
        var label = UILabel()
        label.text = "Price Filter Options"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var ratingLabel: UILabel = {
        var label = UILabel()
        label.text = "Include if No Rating Listed: "
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var noRatingSwitch: UISwitch = {
        let s = UISwitch()
        s.onTintColor = .green
        s.onImage = #imageLiteral(resourceName: "filter")
        s.offImage = #imageLiteral(resourceName: "settings")
        s.addTarget(self, action: #selector(handleSwitch(_:)), for: .valueChanged)
        return s
    }()
    
    lazy var noPriceSwitch: UISwitch = {
        let s = UISwitch()
        s.onTintColor = .green
        s.onImage = #imageLiteral(resourceName: "filter2")
        s.offImage = #imageLiteral(resourceName: "settings")
        s.addTarget(self, action: #selector(handleSwitch(_:)), for: .valueChanged)
        return s
    }()
    
    var noPriceLabel: UILabel = {
        var label = UILabel()
        label.text = "Include if No Price Listed: "
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//                print("**")
//                showMyResultsInNSUserDefaults()
//                print("**")
        
        let shared = UserAppliedFilter.shared
        dollarOneButton.isSelected = shared.getOne
        dollarTwoButton.isSelected = shared.getTwo
        dollarThreeButton.isSelected = shared.getThree
        dollarFourButton.isSelected = shared.getFour
        noPriceSwitch.isOn = shared.getNoPrice
        noRatingSwitch.isOn = shared.getNoRating
        [dollarOneButton, dollarTwoButton, dollarThreeButton, dollarFourButton].forEach{$0.backgroundColor = $0.isSelected ? .white : .clear}
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        let dollarStack: UIStackView = {
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.distribution = .fillEqually
            stack.spacing = 1
            return stack
        }()
        
        let sliderStack: UIStackView = {
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.spacing = 10
            stack.translatesAutoresizingMaskIntoConstraints = false
            return stack
        }()
        
        [sliderLeftLabel, distanceSlider, sliderRightLabel].forEach{sliderStack.addArrangedSubview($0)}
        

        
        [dollarOneButton, dollarTwoButton, dollarThreeButton, dollarFourButton].forEach{dollarStack.addArrangedSubview($0)}
        let isPriceListedStack: UIStackView = {
            let stack = UIStackView()
            stack.spacing = 20
            stack.axis = .horizontal
            [noPriceLabel, noPriceSwitch].forEach{stack.addArrangedSubview($0)}
            return stack
        }()
        
        let isRatingStack: UIStackView = {
            let stack = UIStackView()
            stack.spacing = 20
            stack.axis = .horizontal
            [ratingLabel, noRatingSwitch].forEach{stack.addArrangedSubview($0)}
            return stack
        }()
        
        let myStack: UIStackView = {
            let stack = UIStackView()
            stack.axis = .vertical
            stack.spacing = 20
            stack.translatesAutoresizingMaskIntoConstraints = false
            return stack
        }()
        
        [priceLabel, dollarStack, sliderLabel, sliderStack, sliderValueLabel, isPriceListedStack, isRatingStack, saveButton, cancelButton, defaultButton].forEach{myStack.addArrangedSubview($0)}
        view.addSubview(myStack)
        NSLayoutConstraint.activate([
            myStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            myStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            ])
    }
    
    @objc func handleSaveButton(){
        UserAppliedFilter.shared.save(dollarOne: dollarOneButton.isSelected,
                                    dollarTwo: dollarTwoButton.isSelected,
                                    dollarThree: dollarThreeButton.isSelected,
                                    dollarFour: dollarFourButton.isSelected,
                                    noPrices: noPriceSwitch.isOn,
                                    noRating: noRatingSwitch.isOn,
                                    minimumRating: sliderValueLabel.text ?? "0.0")
        
        self.dismiss(animated: true, completion: {
            UserAppliedFilter.shared.load()
            self.delegate?.undoBlur()
            _ = UserAppliedFilter.shared.getBusinessPredicate()
        })
    }
    
    @objc func handleDefaultButton(){
        [dollarOneButton, dollarTwoButton, dollarThreeButton, dollarFourButton].forEach{
            $0.isSelected = true
            $0.backgroundColor = .white
        }        
        [noRatingSwitch, noPriceSwitch].forEach{$0.isOn = true}
    }
    
    @objc func handlecancelButton(){
        dismiss(animated: true, completion: {
            self.delegate?.undoBlur()
            //print("isFilterOn = \(FilterPredicate.shared.isFilterOn)")
        })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
}


func showMyResultsInNSUserDefaults(){
    let myIndex = ["dollarOne", "dollarTwo", "dollarThree", "dollarFour", "isPriceListed", "isRatingListed"]
    
    var answers = [(key: String, value: Any)]()
    
    for item in Array(UserDefaults.standard.dictionaryRepresentation()) {
        if myIndex.contains(item.key) {
            answers.append(item)
        }
    }
    
    let items = Array(UserDefaults.standard.dictionaryRepresentation())
    print("answers:\n")
    answers.forEach{print($0)}
    print("\n***\ncount --> \(items.count)")
    
}


class UserAppliedFilter {
    static let shared = UserAppliedFilter()
    
    private var dollarOne: Bool?
    private var dollarTwo: Bool?
    private var dollarThree: Bool?
    private var dollarFour: Bool?
    private var priceExists: Bool?
    private var ratingExists: Bool?
    private var minimumRating: String?
    
    var getOne: Bool {return dollarOne ?? false}
    var getTwo: Bool {return dollarTwo ?? false}
    var getThree: Bool {return dollarThree ?? false}
    var getFour: Bool {return dollarFour ?? false}
    var getNoPrice: Bool {return priceExists ?? false}
    var getNoRating: Bool {return ratingExists ?? false}
    var getMinimumRating: String {return minimumRating ?? "0.0"}
    
    func reset(){
        UserDefaults.standard.set(true, forKey: AppConstants.dollarOne.rawValue)
        UserDefaults.standard.set(true, forKey: AppConstants.dollarTwo.rawValue)
        UserDefaults.standard.set(true, forKey: AppConstants.dollarThree.rawValue)
        UserDefaults.standard.set(true, forKey: AppConstants.dollarFour.rawValue)
        UserDefaults.standard.set(true, forKey: AppConstants.isPriceListed.rawValue)
        UserDefaults.standard.set(true, forKey: AppConstants.isRatingListed.rawValue)
        UserDefaults.standard.set("0.0", forKey: AppConstants.minimumRating.rawValue)
    }
    
    func load(){
        dollarOne = UserDefaults.standard.object(forKey: AppConstants.dollarOne.rawValue) as? Bool ?? false
        dollarTwo = UserDefaults.standard.object(forKey: AppConstants.dollarTwo.rawValue) as? Bool ?? false
        dollarThree = UserDefaults.standard.object(forKey: AppConstants.dollarThree.rawValue) as? Bool ?? false
        dollarFour = UserDefaults.standard.object(forKey: AppConstants.dollarFour.rawValue) as? Bool ?? false
        priceExists = UserDefaults.standard.object(forKey: AppConstants.isPriceListed.rawValue) as? Bool ?? false
        ratingExists = UserDefaults.standard.object(forKey: AppConstants.isRatingListed.rawValue) as? Bool ?? false
        minimumRating = UserDefaults.standard.object(forKey: AppConstants.minimumRating.rawValue) as? String ?? "0.0"
    }
    
    
    func save(dollarOne: Bool, dollarTwo: Bool, dollarThree: Bool, dollarFour: Bool, noPrices: Bool, noRating: Bool, minimumRating: String){
        UserDefaults.standard.set(dollarOne, forKey: AppConstants.dollarOne.rawValue)
        UserDefaults.standard.set(dollarTwo, forKey: AppConstants.dollarTwo.rawValue)
        UserDefaults.standard.set(dollarThree, forKey: AppConstants.dollarThree.rawValue)
        UserDefaults.standard.set(dollarFour, forKey: AppConstants.dollarFour.rawValue)
        UserDefaults.standard.set(noPrices, forKey: AppConstants.isPriceListed.rawValue)
        UserDefaults.standard.set(noRating, forKey: AppConstants.isRatingListed.rawValue)
        UserDefaults.standard.set(minimumRating, forKey: AppConstants.minimumRating.rawValue)
    }
    
    var isFilterOn: Bool {
        return !getOne || !getTwo || !getThree || !getFour || !getNoRating || !getNoPrice
    }
    
    func getBusinessPredicate()->[NSCompoundPredicate]{
        var priceOrPredicates = [NSPredicate]()
        var switchAndPredicates = [NSPredicate]()
        
        // OR predicates
        if !(getOne && getTwo && getThree && getFour && getNoPrice) {
            if getOne {priceOrPredicates.append(NSPredicate(format: "%K == %@", argumentArray: [#keyPath(Business.price),"$"]))}
            if getTwo {priceOrPredicates.append(NSPredicate(format: "%K == %@", argumentArray: [#keyPath(Business.price),"$$"]))}
            if getThree {priceOrPredicates.append(NSPredicate(format: "%K == %@", argumentArray: [#keyPath(Business.price),"$$$"]))}
            if getFour {priceOrPredicates.append(NSPredicate(format: "%K == %@", argumentArray: [#keyPath(Business.price),"$$$$"]))}
            if getNoPrice {priceOrPredicates.append(NSPredicate(format: "%K == %@", argumentArray: [#keyPath(Business.price), nil!]))}
        }
        
        //AND predicates
        if getNoPrice {switchAndPredicates.append(NSPredicate(format: "%K == %@", argumentArray: [#keyPath(Business.isDelivery), true]))}
        if getNoRating {switchAndPredicates.append(NSPredicate(format: "%K == %@", argumentArray: [#keyPath(Business.isPickup), true]))}
        
        let orPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: priceOrPredicates)
        let andPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: switchAndPredicates)
        
        var returnPredicate = [NSCompoundPredicate]()
        if !priceOrPredicates.isEmpty {returnPredicate.append(orPredicate)}
//////        if !switchAndPredicates.isEmpty {returnPredicate.append(andPredicate)}
        
        
        if priceOrPredicates.isEmpty && switchAndPredicates.isEmpty {
            return []
        } else {
            return returnPredicate
        }
    }
    
    func getFilteredBusinessArray(businessArray: [Business])->[Business]{
        var answer = [Business]()
        
        if getOne && getTwo && getThree && getFour && !getNoRating && !getNoPrice{
            return businessArray
        }
        
        businessArray.forEach { (first) in
            switch first.price {
            case "$" where getOne: answer.append(first)
            case "$$" where getTwo: answer.append(first)
            case "$$$" where getThree: answer.append(first)
            case "$$$$" where getFour: answer.append(first)
            default:
                if getNoPrice {
                    answer.append(first)
                }
            }
        }
        return answer
    }
    
    func getCategoryPredicate()->[NSCompoundPredicate]{
        var priceOrPredicates = [NSPredicate]()
        var switchAndPredicates = [NSPredicate]()
        
        // OR predicates
        if !(getOne && getTwo && getThree && getFour && getNoPrice) {
            if getOne {priceOrPredicates.append(NSPredicate(format: "%K == %@",
                                                            argumentArray: [#keyPath(Category.business.price),"$"]))}
            if getTwo {priceOrPredicates.append(NSPredicate(format: "%K == %@",
                                                            argumentArray: [#keyPath(Category.business.price),"$$"]))}
            if getThree {priceOrPredicates.append(NSPredicate(format: "%K == %@",
                                                              argumentArray: [#keyPath(Category.business.price),"$$$"]))}
            if getFour {priceOrPredicates.append(NSPredicate(format: "%K == %@",
                                                             argumentArray: [#keyPath(Category.business.price),"$$$$"]))}
            if getNoPrice {priceOrPredicates.append(NSPredicate(format: "%K == %@",
                                                             argumentArray: [#keyPath(Category.business.price), nil!]))}
        }
        
        //AND predicates
        if getNoPrice {switchAndPredicates.append(NSPredicate(format: "%K == %@",
                                                               argumentArray: [#keyPath(Category.business.isDelivery), true]))}
        if getNoRating {switchAndPredicates.append(NSPredicate(format: "%K == %@",
                                                              argumentArray: [#keyPath(Category.business.isPickup), true]))}
        
        let orPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: priceOrPredicates)
        let andPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: switchAndPredicates)
        
        var returnPredicate = [NSCompoundPredicate]()
        if !priceOrPredicates.isEmpty {returnPredicate.append(orPredicate)}
//////        if !switchAndPredicates.isEmpty {returnPredicate.append(andPredicate)}
        
        
        if priceOrPredicates.isEmpty && switchAndPredicates.isEmpty {
            return []
        } else {
            return returnPredicate
        }
    }
}

extension Double {
    func rounded(digits: Int) -> Double {
        let multiplier = pow(10.0, Double(digits))
        return (self * multiplier).rounded() / multiplier
    }
}

extension Float {
    func rounded(digits: Int) -> Float {
        let multiplier = pow(10.0, Float(digits))
        return (self * multiplier).rounded() / multiplier
    }
}
