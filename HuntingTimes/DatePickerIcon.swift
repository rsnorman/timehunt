//
//  DatePickerIcon.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 1/4/15.
//  Copyright (c) 2015 Ryan Norman. All rights reserved.
//

import UIKit
import Foundation

protocol DatePickerIconDelegate {
    func didOpenDatePicker()
    func didCloseDatePicker()
}

class DatePickerIcon : UIView {
    var delegate               : DatePickerIconDelegate!
    var datePickerOpenGesture  : UITapGestureRecognizer!
    var datePickerCloseGesture : UITapGestureRecognizer!
    let padding                : CGFloat = 15
    let borderView             : UIView
    let calendarView           : UIView
    let timeView               : UIView
    
    override init(frame: CGRect) {
        
        borderView = UIView(frame: CGRectMake(padding, padding, frame.width - padding * 2, frame.height - padding * 2))
        borderView.layer.cornerRadius = 5
        borderView.layer.borderColor  = UIColor.whiteColor().CGColor
        borderView.layer.borderWidth  = 1
        
        calendarView   = UIView(frame: borderView.frame)
        timeView       = UIView(frame: borderView.frame)
        timeView.alpha = 0
        
        super.init(frame: frame)
        
        drawCalendar()
        
        drawTime()
        
        addSubview(borderView)
        addSubview(calendarView)
        addSubview(timeView)
        
        datePickerOpenGesture = UITapGestureRecognizer(target: self, action: "datePickerOpen")
        datePickerCloseGesture = UITapGestureRecognizer(target: self, action: "datePickerClose")
        datePickerCloseGesture.enabled = false
        addGestureRecognizer(datePickerOpenGesture)
        addGestureRecognizer(datePickerCloseGesture)
    }
    
    func drawCalendar() {
        let frame   = calendarView.frame
        let topLine = UIView(frame: CGRectMake(0, 10, frame.width, 1))
        topLine.backgroundColor = .whiteColor()
        calendarView.addSubview(topLine)
        
        let middleLine = UIView(frame: CGRectMake(4, ((frame.height - 10) / 3) + 10, frame.width - 8, 1))
        middleLine.backgroundColor = .whiteColor()
        calendarView.addSubview(middleLine)
        
        let bottomLine = UIView(frame: CGRectMake(4, ((frame.height - 10) / 3) * 2 + 10, frame.width - 8, 1))
        bottomLine.backgroundColor = .whiteColor()
        calendarView.addSubview(bottomLine)
    }
    
    func drawTime() {
        let frame = timeView.frame
        
        let hourHand = UIView(frame: CGRectMake(0, 0, frame.width, frame.height))
        let hourLine = UIView(frame: CGRectMake(frame.width / 2, frame.height / 2, frame.width / 2 - 6, 1))
        hourLine.backgroundColor = .whiteColor()
        hourLine.layer.allowsEdgeAntialiasing = true
        hourHand.addSubview(hourLine)
        hourHand.transform = CGAffineTransformRotate(hourHand.transform, CGFloat(M_PI * 0.1))
        timeView.addSubview(hourHand)
        
        let minuteHand = UIView(frame: CGRectMake(0, 0, frame.width, frame.height))
        let minuteLine = UIView(frame: CGRectMake(frame.width / 2, frame.height / 2, frame.width / 2 - 3, 1))
        minuteLine.layer.allowsEdgeAntialiasing = true
        minuteLine.backgroundColor = .whiteColor()
        minuteHand.addSubview(minuteLine)
        minuteHand.transform = CGAffineTransformRotate(minuteHand.transform, CGFloat(M_PI * 0.6))
        timeView.addSubview(minuteHand)
    }
    
    func datePickerOpen() {
        datePickerCloseGesture.enabled  = false
        delegate?.didOpenDatePicker()
        
        UIView.animateWithDuration(0.4, delay: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
            
            let animation = CABasicAnimation(keyPath: "cornerRadius")
            animation.fromValue = self.borderView.layer.cornerRadius
            animation.toValue   = self.borderView.frame.width / 2
            self.borderView.layer.addAnimation(animation, forKey: "cornerRadius")
            self.borderView.layer.cornerRadius = self.borderView.frame.width / 2
            
            self.calendarView.alpha = 0
            self.timeView.alpha = 1
            
            }) { (complete) -> Void in
                self.datePickerCloseGesture.enabled = true
        }
    }
    
    func datePickerClose() {
        datePickerCloseGesture.enabled = false
        delegate?.didCloseDatePicker()
        
        UIView.animateWithDuration(0.4, delay: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
            
            let animation = CABasicAnimation(keyPath: "cornerRadius")
            animation.fromValue = self.borderView.frame.width / 2
            animation.toValue   = 5
            self.borderView.layer.addAnimation(animation, forKey: "cornerRadius")
            self.borderView.layer.cornerRadius = 5
            
            self.calendarView.alpha = 1
            self.timeView.alpha = 0
            
            }) { (complete) -> Void in
                self.datePickerOpenGesture.enabled = true
        }
    }
    
    func enable() {
        datePickerOpenGesture.enabled = true
    }
    
    func disable() {
        datePickerOpenGesture.enabled = false
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
