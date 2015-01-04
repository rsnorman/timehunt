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
    let dateTimeScroller   : ScrollLineView
    let monthColumnView    : ColumnView
    let datepickerLabel    : UILabel
    let menuIcon           : MenuIconView
    let dateLabel          : UILabel
    
    let timeLineHeight   : Int = 200
    
    override init(frame: CGRect) {
        let bgImage = UIImage(named: UserSettings.getBackgroundImage())!
        bgImageView = TiltImageView(image: bgImage, frame: frame)
        shadowView = ShadowView(frame: frame)
        shadowView.setDarkness(0.5)
        
        datepickerLabel       = createLabel("", CGRectMake(0, 60, frame.width, 120), 48)
        datepickerLabel.alpha = 0.0
        
        dateTimeScroller = ScrollLineView(frame: CGRectMake(frame.width / 2, 230, 1, frame.height - 285))
        dateTimeScroller.alpha           = 0.0
        dateTimeScroller.animateDuration = DAY_TRANSITION_TIME
        
        dateLabel = createLabel("", CGRectMake(0, 200, frame.width, 30), 18)
        
        monthColumnView = ColumnView(labels: ["September", "October", "November", "December"], frame: CGRectMake(0, 230, frame.width / 2.0 - 10, frame.height - 285))
        monthColumnView.setTextAlignment(NSTextAlignment.Right)
        monthColumnView.alpha  = 0.0
        monthColumnView.hidden = true
        
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
        
        super.init(frame: frame)
        
        addSubview(bgImageView)
        addSubview(shadowView)
        addSubview(datepickerLabel)
        addSubview(dateTimeScroller)
        addSubview(dateLabel)
        addSubview(monthColumnView)
        addSubview(downArrow)
        addSubview(upArrow)
        addSubview(menuIcon)
    }
    
    func setDelegate(viewController: ViewController) {
        dateTimeScroller.delegate = viewController
        menuIcon.delegate         = viewController
    }
    
    func hideDailyView(hideIndicator: Bool = true) {
        if hideIndicator {
            dateTimeScroller.positionIndicator.alpha = 0
        }
    }
    
    func show() {
        dateTimeScroller.alpha = 0.7
        menuIcon.alpha         = 1.0
        dateTimeScroller.positionIndicator.alpha = 0.7
    }
    
    func isDatePickerVisible() -> Bool {
        return monthColumnView.hidden
    }
    
    func showDatePicker() {
        monthColumnView.alpha = 1.0
        datepickerLabel.alpha = 1.0
    }
    
    func hideDatePicker() {
        monthColumnView.alpha = 0.0
        datepickerLabel.alpha = 0.0
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

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
