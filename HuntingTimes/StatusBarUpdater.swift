//
//  StatusBarUpdater.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 11/21/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import UIKit

class StatusBarUpdater {
    class func black(_ animated: Bool = true) {
        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.default, animated: animated)
    }
    
    class func white(_ animated: Bool = true) {
        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: animated)
    }
    
    class func hide(_ animation: UIStatusBarAnimation = UIStatusBarAnimation.slide) {
        UIApplication.shared.setStatusBarHidden(true, with: animation)
    }
    
    class func show(_ animation: UIStatusBarAnimation = UIStatusBarAnimation.slide) {
        UIApplication.shared.setStatusBarHidden(false, with: animation)
    }
}
