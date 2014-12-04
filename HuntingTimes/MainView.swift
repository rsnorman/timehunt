//
//  MainView.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 11/28/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import UIKit

class MainView : UIView {
    let bgImageView      : TiltImageView
    let shadowView       : ShadowView
    let countdownLabel   : CountdownView
    let dateLabel        : UILabel
    let downArrow        : UIImageView
    let upArrow          : UIImageView
    let dateTimeScroller : ScrollLineView
    let huntingTimesView : HuntingTimesView
    let monthColumnView  : ColumnView
    let stateLabel       : UILabel
    let datepickerLabel  : UILabel
    let messageLabel     : MessageView
    let menuIcon         : MenuIconView
    
    override init(frame: CGRect) {
        let bgImage = UIImage(named: "dark-forest.jpg")!
        bgImageView = TiltImageView(image: bgImage, frame: frame)
        shadowView = ShadowView(frame: frame)
        shadowView.setDarkness(0.5)
        
        messageLabel = MessageView(frame: CGRectMake(10, 75, frame.width - 20, 100))
        messageLabel.alpha    = 0.0
        
        stateLabel = createLabel("", CGRectMake(0, 30, frame.width, 40), 16)
        stateLabel.font = UIFont(name: "HelveticaNeue", size: 16)
        stateLabel.alpha = 0.0
        
        countdownLabel = CountdownView(frame: CGRectMake(0, 55, frame.width, 120))
        countdownLabel.alpha = 0.0
        
        dateLabel             = createLabel("", CGRectMake(0, 185, frame.width, 30), 18)
        dateLabel.alpha       = 0.0
        datepickerLabel       = createLabel("", CGRectMake(0, 60, frame.width, 120), 48)
        datepickerLabel.alpha = 0.0
        
        huntingTimesView = HuntingTimesView(frame: CGRectMake(0, 210, frame.width, frame.height - 260))
        huntingTimesView.alpha = 0.0
        
        dateTimeScroller = ScrollLineView(frame: CGRectMake(frame.width / 2, 220, 1, frame.height - 260))
        dateTimeScroller.alpha           = 0.0
        dateTimeScroller.animateDuration = DAY_TRANSITION_TIME
        
        monthColumnView = ColumnView(labels: ["September", "October", "November", "December"], frame: CGRectMake(0, 220, frame.width / 2.0 - 10, frame.height - 260))
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
        
        menuIcon       = MenuIconView(frame: CGRectMake(10, 25, 30, 30))
        menuIcon.alpha = 0

        super.init(frame: frame)
        
        addSubview(bgImageView)
        addSubview(shadowView)
        addSubview(messageLabel)
        addSubview(stateLabel)
        addSubview(countdownLabel)
        addSubview(dateLabel)
        addSubview(datepickerLabel)
        addSubview(huntingTimesView)
        addSubview(dateTimeScroller)
        addSubview(monthColumnView)
        addSubview(downArrow)
        addSubview(upArrow)
        addSubview(menuIcon)
    }
    
    func setDelegate(viewController: ViewController) {
        messageLabel.delegate = viewController
        countdownLabel.delegate = viewController
        huntingTimesView.delegate = viewController
        dateTimeScroller.delegate = viewController
    }
    
    func hideDailyView(hideIndicator: Bool = true) {
        stateLabel.alpha       = 0
        countdownLabel.alpha   = 0
        dateLabel.alpha        = 0
        huntingTimesView.alpha = 0.0
        
        if hideIndicator {
            dateTimeScroller.positionIndicator.alpha = 0
        }
    }
    
    func showDailyView() {
        stateLabel.alpha       = 1.0
        countdownLabel.alpha   = 1.0
        dateLabel.alpha        = 1.0
        huntingTimesView.alpha = 1.0
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
