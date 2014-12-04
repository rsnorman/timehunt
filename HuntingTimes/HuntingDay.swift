//
//  HuntingDay.swift
//  HuntingDay
//
//  Created by Ryan Norman on 11/27/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import UIKit

class HuntingDay {
    let startTime    : HuntingTime
    let endTime      : HuntingTime
    let sunriseTime  : HuntingTime
    let sunsetTime   : HuntingTime
    lazy var dayBeginning : HuntingTime = {
        return HuntingTime(time: NSCalendar.currentCalendar().dateBySettingHour(0, minute: 0, second: 0, ofDate: self.startTime.time, options: nil)!, event: "DayStart")
    }()
    lazy var dayEnd : HuntingTime = {
        return HuntingTime(time: NSCalendar.currentCalendar().dateBySettingHour(23, minute: 59, second: 59, ofDate: self.endTime.time, options: nil)!, event: "DayEnd")
    }()
    
    init(startTime: NSDate, endTime: NSDate) {
        self.startTime = HuntingTime(time: startTime, event: "Start")
        self.endTime   = HuntingTime(time: endTime, event: "Stop")
        sunriseTime    = HuntingTime(time: startTime.dateByAddingTimeInterval(60 * 30), event: "Sunrise")
        sunsetTime     = HuntingTime(time: endTime.dateByAddingTimeInterval(60 * 30 * -1), event: "Sunset")
    }
    
    init(sunriseTime: NSDate, sunsetTime: NSDate) {
        self.sunriseTime = HuntingTime(time: sunriseTime, event: "Sunrise")
        self.sunsetTime  = HuntingTime(time: sunsetTime, event: "Sunset")
        startTime        = HuntingTime(time: sunriseTime.dateByAddingTimeInterval(60 * 30 * -1), event: "Start")
        endTime          = HuntingTime(time: sunsetTime.dateByAddingTimeInterval(60 * 30), event: "Stop")
    }
    
    func allTimes() -> [HuntingTime] {
        return[startTime, sunriseTime, sunsetTime, endTime]
    }
    
    func getCurrentTime() -> HuntingTime {
        switch getCurrentState() {
            case "starting":
                return startTime
            case "sunrising":
                return sunriseTime
            case "sunsetting":
                return sunsetTime
            case "ending":
                return endTime
            default:
                return dayEnd
        }
    }
    
    func getCurrentState() -> String {
        if startTime.timeIntervalSinceNow() > 0 {
            return "starting"
        } else if sunriseTime.timeIntervalSinceNow() > 0 {
            return "sunrising"
        } else if sunsetTime.timeIntervalSinceNow() > 0 {
            return "sunsetting"
        } else if endTime.timeIntervalSinceNow() > 0 {
            return "ending"
        } else {
            return "ended"
        }
    }
    
    func isEnded() -> Bool {
        return endTime.timeIntervalSinceNow() <= 0
    }
}


