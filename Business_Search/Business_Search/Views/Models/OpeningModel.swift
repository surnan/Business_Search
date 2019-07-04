//
//  OpeningModel.swift
//  Business_Search
//
//  Created by admin on 7/4/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class OpeningModel {
    
//    let nothingFoundView: UILabel = {
//        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 350, height: 350))
//        label.backgroundColor = .clear
//        label.alpha = 0
//        label.text = "That's all Folks"
//        label.textAlignment = .center
//        label.isUserInteractionEnabled = false
//        let textAttributes:[NSAttributedString.Key: Any] = [
//            NSAttributedString.Key.strokeColor: UIColor.lightGray,
//            NSAttributedString.Key.foregroundColor: UIColor.green,
//            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 30)!,
//            NSAttributedString.Key.strokeWidth: -1.0
//        ]
//        label.attributedText = NSAttributedString(string: "No matches found", attributes: textAttributes)
//        return label
//    }()
    
    let nothingFoundView = GenericAttributedTextLabel(text: "No matches found", attributes: greenHelvetica_30_greyStroke)
    
    
    func hideNothingFoundView(){
        nothingFoundView.alpha = 0
    }
    
    func showNothingFoundView(){
        UIView.animate(withDuration: 1.0) {[unowned self] in
            self.nothingFoundView.alpha = 1
        }
    }
}
