//
//  ScrollLine.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 11/24/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import UIKit

class ScrollLineView : UIView {
    
    let middleLine        : UIView
    let positionIndicator : UIView
    var animateDuration   : NSTimeInterval
    
    override init(frame: CGRect) {
        middleLine = UIView(frame: CGRectMake(frame.width / 2, 0, 1, frame.height))
        middleLine.backgroundColor = .whiteColor()
//        middleLine.alpha           = 0.0
        
        positionIndicator = UIView(frame: CGRectMake(frame.width / 2 - 5, 240, 11, 11))
        positionIndicator.layer.cornerRadius = 5.5
        positionIndicator.layer.borderColor  = UIColor.whiteColor().CGColor
        positionIndicator.layer.borderWidth  = 1
        positionIndicator.backgroundColor    = .whiteColor()
//        positionIndicator.alpha              = 0.0
        
        animateDuration = 0.3
        
        super.init(frame: frame)
        
        addSubview(middleLine)
        addSubview(positionIndicator)
    }
    
    func setPosition(percent: CGFloat, animate: Bool = false) {
        if animate {
            UIView.animateWithDuration(animateDuration, animations: { () -> Void in
                self.positionIndicator.frame = CGRectOffset(self.positionIndicator.frame, 0, self.frame.height * percent)
            })
        } else {
            positionIndicator.frame = CGRectOffset(positionIndicator.frame, 0, frame.height * percent)
        }
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}