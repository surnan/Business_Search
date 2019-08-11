//
//  TestVC.swift
//  Business_Search
//
//  Created by admin on 8/11/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import Lottie




class TestVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let myView = LOTAnimationView()
        
        let myView = LOTAnimatedControl()
        myView.animationView.contentMode = .scaleAspectFit
        
        
        view.addSubview(myView)
        
        
        myView.fillSafeSuperView()
        
        myView.animationView.setAnimation(named: "MyDownloader")
        myView.animationView.loopAnimation = true
        myView.animationView.autoReverseAnimation = true
        myView.animationView.play()
        
        print("hello")
        
    }
}
