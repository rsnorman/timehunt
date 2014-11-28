//
//  DateTimeHelper.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 11/26/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import Foundation

func dateToString(dateTime: NSDate, useRelativeString: Bool = true) -> String {
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "MMMM d"
    let dateString = dateFormatter.stringFromDate(dateTime)
    
    if useRelativeString {
        let today       = clearTime(NSDate())
        let compareDate = clearTime(dateTime)
        if dateFormatter.stringFromDate(today) == dateString {
            return "Today"
        } else if compareDate.timeIntervalSinceDate(today) < 0 && compareDate.timeIntervalSinceDate(today) >= -60 * 60 * 24 {
            return "Yesterday"
        } else if compareDate.timeIntervalSinceDate(today) > 0 && compareDate.timeIntervalSinceDate(today) <= 60 * 60 * 24 {
            return "Tomorrow"
        }
    }
    
    return dateString
}

func timeToString(dateTime: NSDate) -> String {
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "h:mm"
    
    return dateFormatter.stringFromDate(dateTime)
}

func clearTime(dateTime: NSDate) -> NSDate {
    let calendar = NSCalendar.currentCalendar()
    return calendar.dateBySettingHour(0, minute: 0, second: 0, ofDate: dateTime, options: nil)!
}