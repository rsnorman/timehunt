//
//  HuntingTime.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 11/28/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import Foundation

struct HuntingTime : NotificationInterface {
    let time  : Date
    let event : String
    
    init(time: Date, event: String) {
        self.time  = time
        self.event = event
    }
    
    func timeIntervalSinceNow() -> TimeInterval {
        return self.time.timeIntervalSinceNow
    }
    
    func timeIntervalSinceDate(_ date: Date) -> TimeInterval {
        return time.timeIntervalSince(date)
    }
    
    func toTimeString() -> String {
        return timeToString(time)
    }
    
    func toDateString() -> String {
        return dateToString(time)
    }
    
    func alert(_ additionalAlertTime: String) -> String {
        if additionalAlertTime == "0 Minutes" {
            switch event {
            case "Start":
                return "Start hunting!"
            case "Sunrise":
                return "The sun has risen"
            case "Sunset":
                return "The sun has set"
            default:
                return "Hunting is over for the day"
            }
        } else {
            switch event {
            case "Start":
                return "Hunting starts in \(additionalAlertTime)"
            case "Sunrise":
                return "The sun rises in  \(additionalAlertTime)"
            case "Sunset":
                return "The sun sets in  \(additionalAlertTime)"
            default:
                return "Hunting ends in  \(additionalAlertTime)"
            }
        }
    }
    
    func message(_ additionalAlertTime: String) -> String {
        if additionalAlertTime == "0 Minutes" {
            return "Added \(event) Notification"
        } else {
            return "Added \(additionalAlertTime) Until \(event) Notification"
        }
    }
    
    func scheduleTime() -> Date {
        return time
    }
    
    func key() -> String {
        return "\(event):\(dateToString(clearTime(time), useRelativeString: false))"
    }
    
    func userInfo() -> [AnyHashable: Any] {
        return [ "time" : time, "event" : event ]
    }
}
