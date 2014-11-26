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
    let middleLine        : UIView
    let positionIndicator : UIView
    var animateDuration   : NSTimeInterval
    var delegate          : ScrollLineViewDelegate!
    
    override init(frame: CGRect) {
        middleLine = UIView(frame: CGRectMake(frame.width / 2, 0, 1, frame.height))
        middleLine.backgroundColor = .whiteColor()
        
        positionIndicator = UIView(frame: CGRectMake(frame.width / 2 - 5, 0, 11, 11))
        positionIndicator.layer.cornerRadius = 5.5
        positionIndicator.layer.borderColor  = UIColor.whiteColor().CGColor
        positionIndicator.layer.borderWidth  = 1
        positionIndicator.backgroundColor    = .whiteColor()
        
        animateDuration = 0.3
        
        super.init(frame: frame)
        
        addSubview(middleLine)
        addSubview(positionIndicator)
    }
    
    func setPosition(percent: CGFloat, animate: Bool = false) {
        let frame = self.positionIndicator.frame
        if animate {
            UIView.animateWithDuration(animateDuration, animations: { () -> Void in
                self.positionIndicator.frame = CGRectMake(frame.origin.x, self.frame.height * percent, frame.width, frame.height)
            })
        } else {
            positionIndicator.frame = CGRectMake(frame.origin.x, self.frame.height * percent, frame.width, frame.height)
        }
    }
    
    func setOffsetPosition(y: CGFloat) {
        let piFrame = self.positionIndicator.frame
        var yOffset = y
        
        if piFrame.origin.y + yOffset < 0 {
            yOffset = piFrame.origin.y * -1
        }
        
        if piFrame.origin.y + yOffset > frame.height {
            yOffset = frame.height - piFrame.origin.y
        }
        
        positionIndicator.frame = CGRectOffset(piFrame, 0, yOffset)
        
        if let del = delegate {
            del.didPositionIndicator(piFrame.origin.y / frame.height)
        }
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}