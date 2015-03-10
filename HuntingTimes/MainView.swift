//
//  MainView.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 11/28/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import UIKit

class MainView : UIView {
    let bgImageView        : TiltImageView
    let shadowView         : ShadowView
    let downArrow          : UIImageView
    let upArrow            : UIImageView
    let dateTimeScroller   : DateLineScroller
    let menuIcon           : MenuIconView
    let datePickerIcon     : DatePickerIcon
    let errorMessage       : ErrorMessageView
    let loadingIndicator   : UIActivityIndicatorView
    
    let timeLineHeight   : Int = 200
    
    override init(frame: CGRect) {
        let bgImage = UIImage(named: UserSettings.getBackgroundImage())!
        bgImageView = TiltImageView(image: bgImage, frame: frame)
        shadowView = ShadowView(frame: frame)
        shadowView.setDarkness(0.5)
        
        dateTimeScroller = DateLineScroller(frame: CGRectMake(0, 210, frame.width, frame.height - 265))
        dateTimeScroller.alpha           = 0.0
        
        let downArrowImage  = UIImage(named: "down-arrow")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        downArrow           = UIImageView(image: downArrowImage)
        downArrow.center    = CGPointMake(frame.width / 2, frame.height - 20)
        downArrow.tintColor = .whiteColor()
        downArrow.alpha     = 0
        
        let upArrowImage  = UIImage(named: "up-arrow")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        upArrow           = UIImageView(image: upArrowImage)
        upArrow.center    = CGPointMake(frame.width / 2, dateTimeScroller.frame.origin.y - 35)
        upArrow.tintColor = .whiteColor()
        upArrow.alpha     = 0
        
        menuIcon       = MenuIconView(frame: CGRectMake(0, 15, 60, 60))
        menuIcon.alpha = 0
        
        datePickerIcon = DatePickerIcon(frame: CGRectMake(frame.width - 60, 15, 60, 60))
        datePickerIcon.alpha = 0
        
        errorMessage = ErrorMessageView(frame: CGRectMake(15, 80, frame.width - 30, 100))
        errorMessage.alpha = 0
        
        loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        loadingIndicator.center = errorMessage.center
        loadingIndicator.alpha = 0.0
        loadingIndicator.hidesWhenStopped = false
        
        super.init(frame: frame)
        
        addSubview(bgImageView)
        addSubview(shadowView)
        addSubview(dateTimeScroller)
        addSubview(datePickerIcon)
        addSubview(errorMessage)
        addSubview(loadingIndicator)
        addSubview(menuIcon)
        
    }
    
    func setDelegate(viewController: MainViewController) {
        menuIcon.delegate         = viewController
        datePickerIcon.delegate   = viewController
        dateTimeScroller.delegate = viewController
    }
    
    func show() {
        dateTimeScroller.alpha = 0.7
        menuIcon.alpha         = 1.0
        datePickerIcon.alpha   = 1.0
    }
    
    func showHints() {
        downArrow.frame = CGRectOffset(downArrow.frame, 0, 5)
        downArrow.alpha = 0.7
        
        upArrow.frame = CGRectOffset(upArrow.frame, 0, -5)
        upArrow.alpha = 0.7
    }
    
    func hideHints() {
        downArrow.frame = CGRectOffset(downArrow.frame, 0, 5)
        downArrow.alpha = 0.0
        
        upArrow.frame = CGRectOffset(upArrow.frame, 0, -5)
        upArrow.alpha = 0.0
    }
    
    func resetHints() {
        downArrow.frame = CGRectOffset(downArrow.frame, 0, -10)
        upArrow.frame   = CGRectOffset(upArrow.frame, 0, 10)
    }
    
    func startLoadingIndicator() {
        self.loadingIndicator.startAnimating()
        UIView.animateWithDuration(0.3, delay: 1.5, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.loadingIndicator.alpha = 0.7
        }) { (complete) -> Void in
        }
    }
    
    func stopLoadingIndicator() {
        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: { () -> Void in
            self.loadingIndicator.alpha = 0
        }) { (complete) -> Void in
            self.loadingIndicator.stopAnimating()
        }
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
