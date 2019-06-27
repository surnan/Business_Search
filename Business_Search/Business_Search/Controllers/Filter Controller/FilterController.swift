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
        label.text = "1"
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
        let intRadius = Int(radius)
        label.text = UserAppliedFilter.shared.getMinimumRatingString
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.textAlignment = .center
        return label
    }()
    
    lazy var distanceSlider: UISlider = {
        var slider = UISlider()
        slider.minimumTrackTintColor = .gray
        slider.maximumTrackTintColor = .black
        slider.minimumValue = 1.0
        slider.maximumValue = 5.0
        slider.value = Float(UserAppliedFilter.shared.getMinimumRatingString) ?? 1.0
        slider.thumbTintColor = .white
        slider.isContinuous = true
        slider.addTarget(self, action: #selector(handleSliderValueChange(_:forEvent:)), for: .valueChanged)
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    @objc func handleSliderValueChange(_ sender: UISlider, forEvent event: UIEvent){
        let temp = sender.value.rounded(digits: 1)
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
        button.addTarget(self, action: #selector(handleResetToDefaultsButton), for: .touchUpInside)
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
        
        let myStack: UIStackView = {
            let stack = UIStackView()
            stack.axis = .vertical
            stack.spacing = 20
            stack.translatesAutoresizingMaskIntoConstraints = false
            return stack
        }()
        
        [priceLabel, dollarStack, sliderLabel, sliderStack, sliderValueLabel, isPriceListedStack, saveButton, cancelButton, defaultButton].forEach{myStack.addArrangedSubview($0)}
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
                                    minimumRating: sliderValueLabel.text ?? "0.0")
        
        self.dismiss(animated: true, completion: {
            UserAppliedFilter.shared.load()
            self.delegate?.undoBlur()
            _ = UserAppliedFilter.shared.getBusinessPredicate()
        })
    }
    
    @objc func handleResetToDefaultsButton(){
        [dollarOneButton, dollarTwoButton, dollarThreeButton, dollarFourButton].forEach{
            $0.isSelected = true
            $0.backgroundColor = .white
        }        
        [noPriceSwitch].forEach{$0.isOn = true}
        distanceSlider.value = 1.0
        sliderValueLabel.text = "1.0"
    }
    
    @objc func handlecancelButton(){
        dismiss(animated: true, completion: {
            self.delegate?.undoBlur()
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







