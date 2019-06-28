//
//  Labels.swift
//  Business_Search
//
//  Created by admin on 6/28/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class MyLabel: UILabel {
    init(text: String, size: CGFloat = 12, backgroundColor: UIColor = UIColor.clear,
         textColor: UIColor = UIColor.white, corner: Bool = false) {
        super.init(frame: .zero)
        self.text = text
        self.font = UIFont.boldSystemFont(ofSize: size)
        self.textColor = .white
        self.textAlignment = .center
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        if corner {
            self.layer.cornerRadius = 10
            self.clipsToBounds = true
        }
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SegmentButton: CustomButton {
    init(title: String, isCorner: Bool = false, corners: CACornerMask = .init()){
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.setTitleColor(.white, for: .normal)
        self.setTitleColor(.black, for: .selected)
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 10
        self.layer.maskedCorners = corners
        self.clipsToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MYButton: UIButton {
    init(title: String, titleColor: UIColor = .black, backgroundColor: UIColor, borderWidth: CGFloat = 0,
         isCorner: Bool = false, corners: CACornerMask = .init()){
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.backgroundColor = backgroundColor
        self.layer.borderWidth = 1
        self.translatesAutoresizingMaskIntoConstraints = false
        if isCorner {
            self.layer.cornerRadius = 10
            self.clipsToBounds = true
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MYSwitch: UISwitch {
    init(onTintColor: UIColor) {
        super.init(frame: .zero)
        self.onTintColor = onTintColor
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MYSlider: UISlider {
    init(min: Float, max: Float, value: Float, minColor: UIColor, maxColor: UIColor, thumbColor: UIColor){
        super.init(frame: .zero)
        self.minimumValue = min
        self.maximumValue = max
        self.value = value
        self.minimumTrackTintColor = minColor
        self.maximumTrackTintColor = maxColor
        self.thumbTintColor = thumbColor
        self.isContinuous = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MYStack: UIStackView {
    init(spacing: CGFloat = 0, axis: NSLayoutConstraint.Axis = .vertical, distribution: UIStackView.Distribution = .fill){
        super.init(frame: .zero)
        self.spacing = spacing
        self.distribution = distribution
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
