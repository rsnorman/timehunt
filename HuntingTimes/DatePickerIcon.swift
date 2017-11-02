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
        
        borderView = UIView(frame: CGRect(x: padding, y: padding, width: frame.width - padding * 2, height: frame.height - padding * 2))
        borderView.layer.cornerRadius = 5
        borderView.layer.borderColor  = UIColor.white.cgColor
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
        
        datePickerOpenGesture = UITapGestureRecognizer(target: self, action: #selector(DatePickerIcon.datePickerOpen))
        datePickerCloseGesture = UITapGestureRecognizer(target: self, action: #selector(DatePickerIcon.datePickerClose))
        datePickerCloseGesture.isEnabled = false
        addGestureRecognizer(datePickerOpenGesture)
        addGestureRecognizer(datePickerCloseGesture)
    }
    
    func drawCalendar() {
        let frame   = calendarView.frame
        let topLine = UIView(frame: CGRect(x: 0, y: 10, width: frame.width, height: 1))
        topLine.backgroundColor = .white
        calendarView.addSubview(topLine)
        
        let middleLine = UIView(frame: CGRect(x: 4, y: ((frame.height - 10) / 3) + 10, width: frame.width - 8, height: 1))
        middleLine.backgroundColor = .white
        calendarView.addSubview(middleLine)
        
        let bottomLine = UIView(frame: CGRect(x: 4, y: ((frame.height - 10) / 3) * 2 + 10, width: frame.width - 8, height: 1))
        bottomLine.backgroundColor = .white
        calendarView.addSubview(bottomLine)
    }
    
    func drawTime() {
        let frame = timeView.frame
        
        let hourHand = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        let hourLine = UIView(frame: CGRect(x: frame.width / 2, y: frame.height / 2, width: frame.width / 2 - 6, height: 1))
        hourLine.backgroundColor = .white
        hourLine.layer.allowsEdgeAntialiasing = true
        hourHand.addSubview(hourLine)
        hourHand.transform = hourHand.transform.rotated(by: CGFloat(.pi * 0.1))
        timeView.addSubview(hourHand)
        
        let minuteHand = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        let minuteLine = UIView(frame: CGRect(x: frame.width / 2, y: frame.height / 2, width: frame.width / 2 - 3, height: 1))
        minuteLine.layer.allowsEdgeAntialiasing = true
        minuteLine.backgroundColor = .white
        minuteHand.addSubview(minuteLine)
        minuteHand.transform = minuteHand.transform.rotated(by: CGFloat(.pi * 0.6))
        timeView.addSubview(minuteHand)
    }
    
    @objc func datePickerOpen() {
        datePickerCloseGesture.isEnabled  = false
        delegate?.didOpenDatePicker()
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options: UIViewAnimationOptions(), animations: { () -> Void in
            
            let animation = CABasicAnimation(keyPath: "cornerRadius")
            animation.fromValue = self.borderView.layer.cornerRadius
            animation.toValue   = self.borderView.frame.width / 2
            self.borderView.layer.add(animation, forKey: "cornerRadius")
            self.borderView.layer.cornerRadius = self.borderView.frame.width / 2
            
            self.calendarView.alpha = 0
            self.timeView.alpha = 1
            
            }) { (complete) -> Void in
                self.datePickerCloseGesture.isEnabled = true
        }
    }
    
    @objc func datePickerClose() {
        datePickerCloseGesture.isEnabled = false
        delegate?.didCloseDatePicker()
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options: UIViewAnimationOptions(), animations: { () -> Void in
            
            let animation = CABasicAnimation(keyPath: "cornerRadius")
            animation.fromValue = self.borderView.frame.width / 2
            animation.toValue   = 5
            self.borderView.layer.add(animation, forKey: "cornerRadius")
            self.borderView.layer.cornerRadius = 5
            
            self.calendarView.alpha = 1
            self.timeView.alpha = 0
            
            }) { (complete) -> Void in
                self.datePickerOpenGesture.isEnabled = true
        }
    }
    
    func enable() {
        datePickerOpenGesture.isEnabled = true
    }
    
    func disable() {
        datePickerOpenGesture.isEnabled = false
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
