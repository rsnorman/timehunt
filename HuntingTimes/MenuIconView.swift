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
        topLine = UIView(frame: CGRect(x: lineHorizontalMargin + padding, y: lineVerticalMargin + padding - (lineHeight / 2), width: frame.width - ((lineHorizontalMargin + padding) * 2), height: lineHeight))
        topLine.backgroundColor = .white
        topLine.layer.cornerRadius = lineHeight / 2
        
        middleLine = UIView(frame: CGRect(x: lineHorizontalMargin + padding, y: frame.height / 2 - (lineHeight / 2), width: frame.width - ((lineHorizontalMargin + padding) * 2), height: lineHeight))
        middleLine.backgroundColor = .white
        middleLine.layer.cornerRadius = lineHeight / 2
        
        bottomLine = UIView(frame: CGRect(x: lineHorizontalMargin + padding, y: frame.height - (lineVerticalMargin + padding + (lineHeight / 2)), width: frame.width - ((lineHorizontalMargin + padding) * 2), height: lineHeight))
        bottomLine.backgroundColor = .white
        bottomLine.layer.cornerRadius = lineHeight / 2
        
        super.init(frame: frame)
        
        addSubview(topLine)
        addSubview(middleLine)
        addSubview(bottomLine)
        
        menuOpenGesture = UITapGestureRecognizer(target: self, action: #selector(MenuIconView.menuOpen))
        menuCloseGesture = UITapGestureRecognizer(target: self, action: #selector(MenuIconView.menuClose))
        menuCloseGesture.isEnabled = false
        addGestureRecognizer(menuOpenGesture)
        addGestureRecognizer(menuCloseGesture)
    }
    
    func menuOpen() {
        menuOpenGesture.isEnabled  = false
        delegate?.didOpenMenu()
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options: UIViewAnimationOptions(), animations: { () -> Void in
            let mFrame = self.middleLine.frame
            self.middleLine.frame = CGRect(x: mFrame.origin.x, y: mFrame.origin.y, width: 0, height: mFrame.height)
            
            let tFrame = self.topLine.frame
            self.topLine.frame = CGRect(x: self.padding, y: self.frame.height / 2 - (self.lineHeight / 2), width: self.frame.width - (self.padding * 2), height: tFrame.height)
            self.topLine.transform = self.topLine.transform.rotated(by: CGFloat(.pi * 0.75))
            
            let bFrame = self.bottomLine.frame
            self.bottomLine.frame = CGRect(x: self.padding, y: self.frame.height / 2 - (self.lineHeight / 2), width: self.frame.width - (self.padding * 2), height: bFrame.height)
            self.bottomLine.transform = self.bottomLine.transform.rotated(by: CGFloat(.pi * -0.75))
        }) { (complete) -> Void in
            self.menuCloseGesture.isEnabled = true
        }
    }
    
    func menuClose() {
        menuCloseGesture.isEnabled = false
        delegate?.didCloseMenu()
        
        // Start rotation first so strange animation doesn't take place
        UIView.animate(withDuration: 0.4, animations: {
            self.topLine.transform = self.topLine.transform.rotated(by: CGFloat(.pi * -0.75))
            self.bottomLine.transform = self.bottomLine.transform.rotated(by: CGFloat(.pi * 0.75))
        }) 
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options: UIViewAnimationOptions(), animations: { () -> Void in
            let mFrame = self.middleLine.frame
            self.middleLine.frame = CGRect(x: mFrame.origin.x, y: mFrame.origin.y, width: self.frame.width - ((self.lineHorizontalMargin + self.padding) * 2), height: mFrame.height)

            let tFrame = self.topLine.frame
            self.topLine.frame = CGRect(x: self.lineHorizontalMargin + self.padding, y: self.lineVerticalMargin + self.padding - (self.lineHeight / 2), width: self.frame.width - ((self.lineHorizontalMargin + self.padding) * 2), height: tFrame.height)
            
//            let bFrame = self.bottomLine.frame
            self.bottomLine.frame = CGRect(x: self.lineHorizontalMargin + self.padding, y: self.frame.height - (self.lineVerticalMargin + self.padding + (self.lineHeight / 2)), width: self.frame.width - ((self.lineHorizontalMargin + self.padding) * 2), height: tFrame.height)
            
        }) { (complete) -> Void in
            self.menuOpenGesture.isEnabled = true
        }
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
