//
//  DateLineScroller.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 1/4/15.
//  Copyright (c) 2015 Ryan Norman. All rights reserved.
//

import Foundation
import UIKit

protocol DateLineScrollerDelegate {
    func didChangeProgress(_ percent: CGFloat)
}

class DateLineScroller: UIView, ScrollLineViewDelegate {
    let scrollLine : ScrollLineView
    let dateLabel  : UILabel
    var delegate   : DateLineScrollerDelegate!
    
    override init(frame: CGRect) {
        scrollLine = ScrollLineView(frame: CGRect(x: frame.width / 2, y: 45, width: 1, height: frame.height - 45))
        scrollLine.animateDuration = DAY_TRANSITION_TIME
        
        dateLabel = createLabel("", frame: CGRect(x: 0, y: 0, width: frame.width, height: 20), fontSize: 18)
        dateLabel.alpha = 1
        
        super.init(frame: frame)
        
        scrollLine.delegate = self
        
        addSubview(scrollLine)
        addSubview(dateLabel)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDate(_ date: Date) {
        dateLabel.text = dateToString(date)
    }
    
    func setProgress(_ percent: CGFloat, animate: Bool) {
        scrollLine.setPosition(percent, animate: animate, notifyDelegate: true)
    }
    
    func markCurrentProgress(_ progress: CGFloat) {
        scrollLine.markCurrentPosition(progress)
    }
    
    func showCurrentProgress() {
        scrollLine.showCurrentPosition()

    }
    
    func hideCurrentProgress() {
        scrollLine.hideCurrentPosition()
    }
    
    func hideIndicator(setProgress progress: CGFloat) {
        UIView.animate(withDuration: DAY_TRANSITION_TIME, animations: { () -> Void in
            self.scrollLine.positionIndicator.alpha = 0
            self.dateLabel.alpha = 0
        }, completion: { (complete) -> Void in
            self.setProgress(progress, animate: false)
        })  
    }
    
    func showIndicator() {
        UIView.animate(withDuration: DAY_TRANSITION_TIME, animations: { () -> Void in
            self.scrollLine.positionIndicator.alpha = 1
            self.dateLabel.alpha = 1
        })
    }
    
    func didPositionIndicator(_ percent: CGFloat) {
        delegate?.didChangeProgress(percent)
    }
}
