//
//  HuntingTimesView.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 11/25/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import UIKit

protocol HuntingTimesViewDelegate {
    func didTapHuntingTime(huntingTime: HuntingTime)
}

class HuntingTimesView : UIView {
    let eventColumnView   : ColumnView
    let timeColumnView    : ColumnView
    let padding           : CGFloat = 15
    let events            : [String] = ["Start", "Sunrise", "Sunset", "Stop"]
    var huntingDay        : HuntingDay!
    var delegate          : HuntingTimesViewDelegate!
    var notificationIcons : [String : [UIView]]
    
    override init(frame: CGRect) {
        eventColumnView = ColumnView(labels: events, frame: CGRectMake(0, 0, frame.width / 2.0 - padding, frame.height))
        eventColumnView.setTextAlignment(NSTextAlignment.Right)
        
        timeColumnView = ColumnView(labels: [], frame: CGRectMake(frame.width / 2.0 + padding, 0, frame.width / 2.0 - padding, frame.height))
        timeColumnView.setTextAlignment(NSTextAlignment.Left)
        
        notificationIcons = [:]
        
        super.init(frame: frame)
        
        for view in eventColumnView.subviews as [UIView] {
            let tapGesture = UITapGestureRecognizer(target: self, action: "didTapEvent:")
            view.userInteractionEnabled = true
            view.addGestureRecognizer(tapGesture)
        }
        
        addSubview(eventColumnView)
        addSubview(timeColumnView)
    }
    
    func didTapEvent(sender: UITapGestureRecognizer) {
        let loc   = sender.locationInView(self)
        if let label = self.hitTest(loc, withEvent: nil) as? UILabel {
            let event = label.text
            let time  = huntingDay.allTimes()[find(events, event!)!]
            
            if let del = delegate {
                del.didTapHuntingTime(time)
            }
        }
    }
    
    func didTapTime(sender: UITapGestureRecognizer) {
        let loc   = sender.locationInView(self)
        if let label = self.hitTest(loc, withEvent: nil) as? UILabel {
            let timeString = label.text
            let timesString = huntingDay.allTimes().map {
                $0.toTimeString()
            }
            let time  = huntingDay.allTimes()[find(timesString, timeString!)!]
            let event = events[find(timesString, timeString!)!]
                
            if let del = delegate {
                del.didTapHuntingTime(time)
            }
        }
    }
    
    func getPositionOfTime(time: NSDate) -> Int? {
        if let day = huntingDay {
            let timesString = huntingDay.allTimes().map {
                $0.toTimeString()
            }
            return find(timesString, timeToString(time))
        }
        return nil
    }
    
    func findEventLabelFromTime(time: NSDate) -> UILabel? {
        if let position = getPositionOfTime(time) {
            return eventColumnView.subviews[position] as? UILabel
        }
        return nil
    }
    
    func addNotificationIcon(time: NSDate, animate: Bool = true) {
        if let label = findEventLabelFromTime(time) {
            let eventText = label.text!

            if notificationIcons[eventText] == nil {
                notificationIcons[eventText] = []
            }
            
            let xOffset                         = CGFloat(14 * notificationIcons[eventText]!.count) + 15
            let notificationIcon                = UIView(frame: CGRectMake(label.frame.origin.x - xOffset, label.center.y - 3, 8, 8))
            notificationIcon.backgroundColor    = .whiteColor()
            notificationIcon.layer.cornerRadius = 4
            notificationIcon.alpha              = 0.6
            
            notificationIcons[eventText]!.append(notificationIcon)
            
            addSubview(notificationIcon)
            
            if animate {
                notificationIcon.alpha = 0.0
                notificationIcon.frame = CGRectOffset(notificationIcon.frame, -8, 0)
                
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    notificationIcon.alpha = 0.6
                    notificationIcon.frame = CGRectOffset(notificationIcon.frame, 8, 0)
                })
            }
        }
    }
    
    func removeNotificationIcon(time: NSDate, event: String) {
        if let icons = notificationIcons[event] {
            if let removeIcon = icons.last {
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    removeIcon.frame = CGRectOffset(removeIcon.frame, 0, 15)
                    removeIcon.alpha = 0.0
                    }, completion: { (complete) -> Void in
                        removeIcon.removeFromSuperview()
                        self.notificationIcons[event]!.removeLast()
                })
            }
        }
    }
    
    func removeNotificationIcons(time: NSDate) {
        if let label = findEventLabelFromTime(time) {
            let eventText = label.text!
            if let icons = notificationIcons[eventText] {
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    for icon in icons {
                        icon.frame = CGRectOffset(icon.frame, 0, 15)
                        icon.alpha = 0.0
                    }
                }, completion: { (complete) -> Void in
                    self.notificationIcons[eventText] = []
                })
            }
        }
    }
    
    func removeAllNotifications() {
        for (event, nIcons) in notificationIcons {
            for nIcon in nIcons {
                nIcon.removeFromSuperview()
            }
        }
        notificationIcons = [:]
    }
    
    func setDay(huntingDay: HuntingDay) {
        self.huntingDay = huntingDay
        timeColumnView.setLabels([huntingDay.startTime.toTimeString(), huntingDay.sunriseTime.toTimeString(), huntingDay.sunsetTime.toTimeString(), huntingDay.endTime.toTimeString()])
        removeAllNotifications()
        
        for view in timeColumnView.subviews as [UIView] {
            let tapGesture = UITapGestureRecognizer(target: self, action: "didTapTime:")
            view.userInteractionEnabled = true
            view.addGestureRecognizer(tapGesture)
        }
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
