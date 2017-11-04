//
//  HuntingDay.swift
//  HuntingDay
//
//  Created by Ryan Norman on 11/27/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import UIKit

class HuntingDay {
    let date         : Date
    var startTime    : HuntingTime!
    var endTime      : HuntingTime!
    var sunriseTime  : HuntingTime!
    var sunsetTime   : HuntingTime!
    lazy var dayBeginning : HuntingTime = {
        return HuntingTime(time: self.date, event: "DayStart")
    }()
    lazy var dayEnd : HuntingTime = {
        return HuntingTime(time: Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: self.date)!, event: "DayEnd")
    }()
    
    var weather : DailyWeather!
    
    init(date: Date) {
        self.date = date
    }
    
    func setSunriseSunset(_ sunriseTime: Date, sunsetTime: Date) {
        self.sunriseTime = HuntingTime(time: sunriseTime, event: "Sunrise")
        self.sunsetTime  = HuntingTime(time: sunsetTime, event: "Sunset")
        startTime        = HuntingTime(time: sunriseTime.addingTimeInterval(60 * 30 * -1), event: "Start")
        endTime          = HuntingTime(time: sunsetTime.addingTimeInterval(60 * 30), event: "Stop")
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


