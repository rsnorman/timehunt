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
    func didCloseMenu()
}

class MenuIconView : UIView {
    let lineHorizontalMargin : CGFloat = 8
    let lineVerticalMargin   : CGFloat = 12
    let lineHeight           : CGFloat = 2
    let padding              : CGFloat = 10
    var delegate             : MenuIconViewDelegate!
    let topLine              : UIView
    let middleLine           : UIView
    let bottomLine           : UIView
    var menuOpenGesture      : UITapGestureRecognizer!
    var menuCloseGesture     : UITapGestureRecognizer!
    
    override init(frame: CGRect) {
        topLine = UIView(frame: CGRectMake(lineHorizontalMargin + padding, lineVerticalMargin + padding - (lineHeight / 2), frame.width - ((lineHorizontalMargin + padding) * 2), lineHeight))
        topLine.backgroundColor = .whiteColor()
        topLine.layer.cornerRadius = lineHeight / 2
        
        middleLine = UIView(frame: CGRectMake(lineHorizontalMargin + padding, frame.height / 2 - (lineHeight / 2), frame.width - ((lineHorizontalMargin + padding) * 2), lineHeight))
        middleLine.backgroundColor = .whiteColor()
        middleLine.layer.cornerRadius = lineHeight / 2
        
        bottomLine = UIView(frame: CGRectMake(lineHorizontalMargin + padding, frame.height - (lineVerticalMargin + padding + (lineHeight / 2)), frame.width - ((lineHorizontalMargin + padding) * 2), lineHeight))
        bottomLine.backgroundColor = .whiteColor()
        bottomLine.layer.cornerRadius = lineHeight / 2
        
        super.init(frame: frame)
        
        addSubview(topLine)
        addSubview(middleLine)
        addSubview(bottomLine)
        
        menuOpenGesture = UITapGestureRecognizer(target: self, action: "menuOpen")
        menuCloseGesture = UITapGestureRecognizer(target: self, action: "menuClose")
        menuCloseGesture.enabled = false
        addGestureRecognizer(menuOpenGesture)
        addGestureRecognizer(menuCloseGesture)
    }
    
    func menuOpen() {
        menuOpenGesture.enabled  = false
        delegate?.didOpenMenu()
        
        UIView.animateWithDuration(0.4, delay: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
            let mFrame = self.middleLine.frame
            self.middleLine.frame = CGRectMake(mFrame.origin.x, mFrame.origin.y, 0, mFrame.height)
            
            let tFrame = self.topLine.frame
            self.topLine.frame = CGRectMake(self.padding, self.frame.height / 2 - (self.lineHeight / 2), self.frame.width - (self.padding * 2), tFrame.height)
            self.topLine.transform = CGAffineTransformRotate(self.topLine.transform, CGFloat(M_PI * 0.75))
            
            let bFrame = self.bottomLine.frame
            self.bottomLine.frame = CGRectMake(self.padding, self.frame.height / 2 - (self.lineHeight / 2), self.frame.width - (self.padding * 2), bFrame.height)
            self.bottomLine.transform = CGAffineTransformRotate(self.bottomLine.transform, CGFloat(M_PI * -0.75))
        }) { (complete) -> Void in
            self.menuCloseGesture.enabled = true
        }
    }
    
    func menuClose() {
        menuCloseGesture.enabled = false
        delegate?.didCloseMenu()
        
        // Start rotation first so strange animation doesn't take place
        UIView.animateWithDuration(0.4) {
            self.topLine.transform = CGAffineTransformRotate(self.topLine.transform, CGFloat(M_PI * -0.75))
            self.bottomLine.transform = CGAffineTransformRotate(self.bottomLine.transform, CGFloat(M_PI * 0.75))
        }
        
        UIView.animateWithDuration(0.4, delay: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
            let mFrame = self.middleLine.frame
            self.middleLine.frame = CGRectMake(mFrame.origin.x, mFrame.origin.y, self.frame.width - ((self.lineHorizontalMargin + self.padding) * 2), mFrame.height)

            let tFrame = self.topLine.frame
            self.topLine.frame = CGRectMake(self.lineHorizontalMargin + self.padding, self.lineVerticalMargin + self.padding - (self.lineHeight / 2), self.frame.width - ((self.lineHorizontalMargin + self.padding) * 2), tFrame.height)
            
            let bFrame = self.bottomLine.frame
            self.bottomLine.frame = CGRectMake(self.lineHorizontalMargin + self.padding, self.frame.height - (self.lineVerticalMargin + self.padding + (self.lineHeight / 2)), self.frame.width - ((self.lineHorizontalMargin + self.padding) * 2), tFrame.height)
            
        }) { (complete) -> Void in
            self.menuOpenGesture.enabled = true
        }
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}