//
//  SettingsController.swift
//  Business_Search
//
//  Created by admin on 5/23/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class SettingsController: UIViewController {
    
    lazy var distanceSlider: UISlider = {
        var slider = UISlider()
        slider.minimumTrackTintColor = .blue
        slider.maximumTrackTintColor = .red
        slider.minimumValue = 0
        slider.maximumValue = 1000
        slider.value = Float(radius)
        slider.thumbTintColor = .purple
        slider.isContinuous = true
        slider.addTarget(self, action: #selector(handleSliderTouchUpInside(_:forEvent:)), for: .touchUpInside)
        slider.addTarget(self, action: #selector(handleSliderValueChange(_:forEvent:)), for: .valueChanged)
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    
    @objc func handleSliderValueChange(_ sender: UISlider, forEvent event: UIEvent){
        let intRadius = Int(sender.value)
        sliderValueLabel.text = "\(intRadius)"
    }
    
    @objc func handleSliderTouchUpInside(_ sender: UISlider, forEvent event: UIEvent){
        print("Final Value = \(sender.value)")
    }
    
    var sliderLeftLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var sliderRightLabel: UILabel = {
        let label = UILabel()
        label.text = "1000"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(handleDismissButton), for: .touchUpInside)
        button.backgroundColor = UIColor.white
        button.setTitle("     DISMISS     ", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var sliderValueLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .blue
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .white
        let intRadius = Int(radius)
        label.text = "\(intRadius)"
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.lightGray
        let stackView: UIStackView = {
            let stack = UIStackView()
            stack.axis = .vertical
            stack.spacing = 50
            stack.translatesAutoresizingMaskIntoConstraints = false
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
        [sliderValueLabel, dismissButton].forEach{stackView.addArrangedSubview($0)}
        [stackView, sliderStack].forEach{view.addSubview($0)}
        
        NSLayoutConstraint.activate([
            sliderStack.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.66),
            sliderStack.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -30),
            sliderStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: sliderStack.bottomAnchor, constant: 30),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ])
    }
    
    
    //MARK:- Handlers
    @objc func handleDismissButton(){
        dismiss(animated: true, completion: nil)
    }
}
