//
//  MenuIconView.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 12/3/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import UIKit
import Foundation

protocol MenuIconViewDelegate {
    func didOpenMenu()
//    func didCloseMenu()
}

class MenuIconView : UIView {
    let lineHorizontalMargin : CGFloat = 6
    let lineVerticalMargin   : CGFloat = 10
    let lineHeight           : CGFloat = 2
    var delegate             : MenuIconViewDelegate!
    let topLine              : UIView
    let middleLine           : UIView
    let bottomLine           : UIView
    
    override init(frame: CGRect) {
        topLine = UIView(frame: CGRectMake(lineHorizontalMargin, lineVerticalMargin - (lineHeight / 2), frame.width - (lineHorizontalMargin * 2), lineHeight))
        topLine.backgroundColor = .whiteColor()
        topLine.layer.cornerRadius = lineHeight / 2
        
        middleLine = UIView(frame: CGRectMake(lineHorizontalMargin, frame.height / 2 - (lineHeight / 2), frame.width - (lineHorizontalMargin * 2), lineHeight))
        middleLine.backgroundColor = .whiteColor()
        middleLine.layer.cornerRadius = lineHeight / 2
        
        bottomLine = UIView(frame: CGRectMake(lineHorizontalMargin, frame.height - (lineVerticalMargin + (lineHeight / 2)), frame.width - (lineHorizontalMargin * 2), lineHeight))
        bottomLine.backgroundColor = .whiteColor()
        bottomLine.layer.cornerRadius = lineHeight / 2
        
        super.init(frame: frame)
        
        self.layer.borderWidth  = 1.0
        self.layer.cornerRadius = frame.width / 2.0
        self.layer.borderColor  = UIColor.whiteColor().CGColor
        
        addSubview(topLine)
        addSubview(middleLine)
        addSubview(bottomLine)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "menuOpened")
        addGestureRecognizer(tapGesture)
    }
    
    func menuOpened() {
        
        UIView.animateWithDuration(0.4, delay: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
            let mFrame = self.middleLine.frame
            self.middleLine.frame = CGRectMake(mFrame.origin.x, mFrame.origin.y, 0, mFrame.height)
            
            let tFrame = self.topLine.frame
            self.topLine.frame = CGRectMake(0, self.frame.height / 2 - (self.lineHeight / 2), self.frame.width, tFrame.height)
            self.topLine.transform = CGAffineTransformRotate(self.topLine.transform, CGFloat(M_PI * 0.75))
            
            let bFrame = self.bottomLine.frame
            self.bottomLine.frame = CGRectMake(0, self.frame.height / 2 - (self.lineHeight / 2), self.frame.width, bFrame.height)
            self.bottomLine.transform = CGAffineTransformRotate(self.bottomLine.transform, CGFloat(M_PI * -0.75))
        }, completion: nil)
        
        delegate?.didOpenMenu()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}