//
//  DateLineScroller.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 1/4/15.
//  Copyright (c) 2015 Ryan Norman. All rights reserved.
//

import Foundation

class DateLineScroller: UIView {
    let scrollLine : ScrollLineView
    let dateLabel  : UILabel
    
    override init(frame: CGRect) {
        scrollLine = ScrollLineView(frame: CGRectMake(frame.width / 2, 25, 1, frame.height - 25))
        scrollLine.animateDuration = DAY_TRANSITION_TIME
        
        dateLabel = createLabel("", CGRectMake(0, 0, frame.width, 20), 18)
        dateLabel.alpha = 1
        
        super.init(frame: frame)
        
        addSubview(scrollLine)
        addSubview(dateLabel)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDate(date: NSDate) {
        dateLabel.text = dateToString(date)
    }
    
    func setProgress(percent: CGFloat, animate: Bool) {
        scrollLine.setPosition(percent, animate: animate)
    }
    
    func markCurrentProgress(progress: CGFloat) {
        scrollLine.markCurrentPosition(progress)
    }
    
    func showCurrentProgress() {
        scrollLine.showCurrentPosition()
    }
    
    func hideCurrentProgress() {
        scrollLine.hideCurrentPosition()
    }
    
    func hideIndicator(setProgress progress: CGFloat) {
        UIView.animateWithDuration(DAY_TRANSITION_TIME, animations: { () -> Void in
            self.scrollLine.positionIndicator.alpha = 0
        })  { (complete) -> Void in
            self.setProgress(progress, animate: false)
        }
    }
    
    func showIndicator() {
        UIView.animateWithDuration(DAY_TRANSITION_TIME, animations: { () -> Void in
            self.scrollLine.positionIndicator.alpha = 1
        })
    }
}
