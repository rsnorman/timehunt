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
    let dateTimeScroller   : DateLineScroller
    let menuIcon           : MenuIconView
    let datePickerIcon     : DatePickerIcon
    let errorMessage       : ErrorMessageView
    let loadingIndicator   : UIActivityIndicatorView
    
    let timeLineHeight   : Int = 200
    
    override init(frame: CGRect) {
        let bgImage = UIImage(named: UserSettings.getBackgroundImage() as String)!
        bgImageView = TiltImageView(image: bgImage, frame: frame)
        shadowView = ShadowView(frame: frame)
        shadowView.setDarkness(0.5)
        
        dateTimeScroller = DateLineScroller(frame: createPageViewRect(0, width: frame.width, topPadding: 50))
        dateTimeScroller.alpha           = 0.0
        
        menuIcon       = MenuIconView(frame: CGRect(x: 0, y: 15, width: 60, height: 60))
        menuIcon.alpha = 0
        
        datePickerIcon = DatePickerIcon(frame: CGRect(x: frame.width - 60, y: 15, width: 60, height: 60))
        datePickerIcon.alpha = 0
        
        errorMessage = ErrorMessageView(frame: CGRect(x: 15, y: 80, width: frame.width - 30, height: 100))
        errorMessage.alpha = 0
        
        loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
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
    
    func setDelegate(_ viewController: MainViewController) {
        menuIcon.delegate         = viewController
        datePickerIcon.delegate   = viewController
        dateTimeScroller.delegate = viewController
    }
    
    func show() {
        dateTimeScroller.alpha = 0.7
        menuIcon.alpha         = 1.0
        datePickerIcon.alpha   = 1.0
    }
    
    func startLoadingIndicator() {
        self.loadingIndicator.startAnimating()
        UIView.animate(withDuration: 0.3, delay: 1.5, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
            self.loadingIndicator.alpha = 0.7
        }) { (complete) -> Void in
        }
    }
    
    func stopLoadingIndicator() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: { () -> Void in
            self.loadingIndicator.alpha = 0
        }) { (complete) -> Void in
            self.loadingIndicator.stopAnimating()
        }
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
