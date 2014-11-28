//
//  HuntingDay.swift
//  HuntingDay
//
//  Created by Ryan Norman on 11/27/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import UIKit

struct HuntingTime {
    var time  : NSDate
    var event : String
}

class HuntingDay {
    
    let states : [String] = ["Start", "Sunrise", "Sunset", "Stop", "Ended"]
    let events : [String:String] = [
        "starting"   : "Start",
        "sunrising"  : "Sunrise",
        "sunsetting" : "Sunset",
        "ending"     : "Stop",
        "ended"      : "Ended"
    ]
    
    let startTime   : NSDate
    let endTime     : NSDate
    let sunriseTime : NSDate
    let sunsetTime  : NSDate
    
    init(startTime: NSDate, endTime: NSDate) {
        self.startTime   = startTime
        self.endTime     = endTime
        sunriseTime = startTime.dateByAddingTimeInterval(60 * 60)
        sunsetTime  = endTime.dateByAddingTimeInterval(60 * 30 * -1)
    }
    
    func getBeginningOfDay() -> NSDate {
        return NSCalendar.currentCalendar().dateBySettingHour(0, minute: 0, second: 0, ofDate: startTime, options: nil)!
    }
    
    func getEndOfDay() -> NSDate {
        return NSCalendar.currentCalendar().dateBySettingHour(23, minute: 59, second: 59, ofDate: endTime, options: nil)!
    }
    
    func allTimes() -> [NSDate] {
        return[startTime, sunriseTime, sunsetTime, endTime]
    }
    
    func getTimeFromState(state: String) -> NSDate {
        switch state {
            case "starting":
                return startTime
            case "sunrising":
                return sunriseTime
            case "sunsetting":
                return sunsetTime
            case "ending":
                return endTime
            default:
                return getEndOfDay()
        }
    }
    
    func getCurrentState() -> String {
        if startTime.timeIntervalSinceNow > 0 {
            return "starting"
        } else if sunriseTime.timeIntervalSinceNow > 0 {
            return "sunrising"
        } else if sunsetTime.timeIntervalSinceNow > 0 {
            return "sunsetting"
        } else if endTime.timeIntervalSinceNow > 0 {
            return "ending"
        } else {
            return "ended"
        }
    }
}


