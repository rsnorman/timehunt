//
//  DateLineScroller.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 1/4/15.
//  Copyright (c) 2015 Ryan Norman. All rights reserved.
//

import Foundation

protocol DateLineScrollerDelegate {
    func didChangeProgress(percent: CGFloat)
}

class DateLineScroller: UIView, ScrollLineViewDelegate {
    let scrollLine : ScrollLineView
    let dateLabel  : UILabel
    var delegate   : DateLineScrollerDelegate!
    
    override init(frame: CGRect) {
        scrollLine = ScrollLineView(frame: CGRectMake(frame.width / 2, 25, 1, frame.height - 25))
        scrollLine.animateDuration = DAY_TRANSITION_TIME
        
        dateLabel = createLabel("", CGRectMake(0, 0, frame.width, 20), 18)
        dateLabel.alpha = 1
        
        super.init(frame: frame)
        
        scrollLine.delegate = self
        
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
    
    func setOffsetProgress(amount: CGFloat) {
        scrollLine.setOffsetPosition(amount)
    }
    
    func markCurrentProgress(progress: CGFloat) {
        scrollLine.markCurrentPosition(progress)
    }
    
    func showCurrentProgress() {
        scrollLine.showCurrentPosition()
        dateLabel.alpha = 1
    }
    
    func hideCurrentProgress() {
        scrollLine.hideCurrentPosition()
        dateLabel.alpha = 0
    }
    
    func hideIndicator(setProgress progress: CGFloat) {
        UIView.animateWithDuration(DAY_TRANSITION_TIME, animations: { () -> Void in
            self.hideCurrentProgress()
        })  { (complete) -> Void in
            self.setProgress(progress, animate: false)
        }
    }
    
    func showIndicator() {
        UIView.animateWithDuration(DAY_TRANSITION_TIME, animations: { () -> Void in
            self.showCurrentProgress()
        })
    }
    
    func didPositionIndicator(percent: CGFloat) {
        delegate?.didChangeProgress(percent)
    }
}
