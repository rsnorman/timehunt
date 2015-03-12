//
//  ScrollLine.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 11/24/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import UIKit

protocol ScrollLineViewDelegate {
    func didPositionIndicator(percent: CGFloat)
}

class ScrollLineView : UIView {
    let middleLine               : UIView
    let positionIndicator        : UIView
    let currentPositionIndicator : UIView
    var animateDuration          : NSTimeInterval
    var delegate                 : ScrollLineViewDelegate!
    
    override init(frame: CGRect) {
        middleLine = UIView(frame: CGRectMake(frame.width / 2, 0, 1, frame.height))
        middleLine.backgroundColor = .whiteColor()
        
        positionIndicator = UIView(frame: CGRectMake(frame.width / 2 - 5, 0, 11, 11))
        positionIndicator.layer.cornerRadius = 5.5
        positionIndicator.layer.borderColor  = UIColor.whiteColor().CGColor
        positionIndicator.layer.borderWidth  = 1
        positionIndicator.backgroundColor    = .whiteColor()
        
        currentPositionIndicator = UIView(frame: CGRectMake(frame.width / 2 - 5, 0, 11, 11))
        currentPositionIndicator.layer.cornerRadius = 5.5
        currentPositionIndicator.layer.borderColor  = UIColor.whiteColor().CGColor
        currentPositionIndicator.layer.borderWidth  = 1
        currentPositionIndicator.backgroundColor    = UIColor(white: 1, alpha: 0.7)
        currentPositionIndicator.alpha              = 0.0
        
        animateDuration = 0.3
        
        super.init(frame: frame)
        
        addSubview(middleLine)
        addSubview(positionIndicator)
        addSubview(currentPositionIndicator)
    }
    
    func setPosition(percent: CGFloat, animate: Bool = false, notifyDelegate: Bool = false) {
        if animate {
            UIView.animateWithDuration(animateDuration, animations: { () -> Void in
                self.positionIndicatorFromPercent(percent, notifyDelegate: notifyDelegate)
            })
        } else {
            positionIndicatorFromPercent(percent, notifyDelegate: notifyDelegate)
        }
    }
    
    func positionIndicatorFromPercent(percent: CGFloat, notifyDelegate: Bool) {
        let pFrame = positionIndicator.frame
        positionIndicator.frame = CGRectMake(pFrame.origin.x, frame.height * percent, pFrame.width, pFrame.height)
        
        if notifyDelegate {
            delegate?.didPositionIndicator(pFrame.origin.y / frame.height)
        }
    }
    
    func markCurrentPosition(percent: CGFloat) {
        let cpFrame = currentPositionIndicator.frame
        currentPositionIndicator.frame = CGRectMake(cpFrame.origin.x, frame.height * percent, cpFrame.width, cpFrame.height)
    }
    
    func showCurrentPosition() {
        currentPositionIndicator.alpha = 0.8
    }
    
    func hideCurrentPosition() {
        currentPositionIndicator.alpha = 0.0
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}