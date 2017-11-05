//
//  ScrollLine.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 11/24/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import UIKit

protocol ScrollLineViewDelegate {
    func didPositionIndicator(_ percent: CGFloat)
}

class ScrollLineView : UIView {
    let middleLine               : UIView
    let positionIndicator        : UIView
    let currentPositionIndicator : UIView
    var animateDuration          : TimeInterval
    var delegate                 : ScrollLineViewDelegate!
    let indicatorDiameter        : CGFloat = 11
    let indicatorRadius          : CGFloat = 11 / 2
    
    override init(frame: CGRect) {
        middleLine = UIView(frame: CGRect(x: frame.width / 2, y: indicatorRadius, width: 1, height: frame.height - indicatorRadius))
        middleLine.backgroundColor = .white
        
        positionIndicator = UIView(frame: CGRect(x: frame.width / 2 - indicatorRadius, y: 0, width: indicatorDiameter, height: indicatorDiameter))
        positionIndicator.layer.cornerRadius = indicatorRadius
        positionIndicator.layer.borderColor  = UIColor.white.cgColor
        positionIndicator.layer.borderWidth  = 1
        positionIndicator.backgroundColor    = .white
        
        currentPositionIndicator = UIView(frame: CGRect(x: frame.width / 2 - indicatorRadius, y: 0, width: indicatorDiameter, height: indicatorDiameter))
        currentPositionIndicator.layer.cornerRadius = indicatorRadius
        currentPositionIndicator.layer.borderColor  = UIColor.white.cgColor
        currentPositionIndicator.layer.borderWidth  = 1
        currentPositionIndicator.backgroundColor    = UIColor(white: 1, alpha: 0.7)
        currentPositionIndicator.alpha              = 0.0
        
        animateDuration = 0.3
        
        super.init(frame: frame)
        
        addSubview(middleLine)
        addSubview(positionIndicator)
        addSubview(currentPositionIndicator)
    }
    
    func setPosition(_ percent: CGFloat, animate: Bool = false, notifyDelegate: Bool = false) {
        if animate {
            UIView.animate(withDuration: animateDuration, animations: { () -> Void in
                self.positionIndicatorFromPercent(percent, notifyDelegate: notifyDelegate)
            })
        } else {
            positionIndicatorFromPercent(percent, notifyDelegate: notifyDelegate)
        }
    }
    
    func positionIndicatorFromPercent(_ percent: CGFloat, notifyDelegate: Bool) {
        let pFrame = positionIndicator.frame
        positionIndicator.frame = CGRect(x: pFrame.origin.x, y: (frame.height - indicatorRadius) * percent, width: pFrame.width, height: pFrame.height)
        
        if notifyDelegate {
            delegate?.didPositionIndicator(percent)
        }
    }
    
    func markCurrentPosition(_ percent: CGFloat) {
        let cpFrame = currentPositionIndicator.frame
        currentPositionIndicator.frame = CGRect(x: cpFrame.origin.x, y: (frame.height - indicatorRadius) * percent, width: cpFrame.width, height: cpFrame.height)
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
