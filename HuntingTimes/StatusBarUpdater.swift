//
//  StatusBarUpdater.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 11/21/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import UIKit

class StatusBarUpdater {
    class func black(animated: Bool = true) {
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.Default, animated: animated)
    }
    
    class func white(animated: Bool = true) {
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: animated)
    }
    
    class func hide(animation: UIStatusBarAnimation = UIStatusBarAnimation.Slide) {
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: animation)
    }
    
    class func show(animation: UIStatusBarAnimation = UIStatusBarAnimation.Slide) {
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: animation)
    }
}
