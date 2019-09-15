//
//  LottieController.swift
//  Business_Search
//
//  Created by admin on 9/14/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import Lottie


class LottieController: UIViewController {
    var animationView = LOTAnimationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(animationView)
        animationView.fillSafeSuperView()
        playAnimation()
    }

    func playAnimation(){
        animationView.setAnimation(named: downloadJSON)
        animationView.loopAnimation = true
        animationView.play()
    }
}
