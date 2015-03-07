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

func isToday(date: NSDate) -> Bool {
    let cal = NSCalendar.currentCalendar()
    var components = cal.components((NSCalendarUnit.CalendarUnitEra|NSCalendarUnit.CalendarUnitYear|NSCalendarUnit.CalendarUnitMonth|NSCalendarUnit.CalendarUnitDay), fromDate: NSDate())
    let today = cal.dateFromComponents(components)
    components = cal.components((NSCalendarUnit.CalendarUnitEra|NSCalendarUnit.CalendarUnitYear|NSCalendarUnit.CalendarUnitMonth|NSCalendarUnit.CalendarUnitDay), fromDate: date)
    let otherDate = cal.dateFromComponents(components)
    
    return today!.isEqualToDate(otherDate!)
}

func differenceInDays(date: NSDate, otherDate: NSDate) -> Int {
    let calendar = NSCalendar.currentCalendar()
    var fromDate : NSDate?
    var toDate   : NSDate?
    var duration : NSTimeInterval = 0
    
    calendar.rangeOfUnit(.DayCalendarUnit, startDate: &fromDate, interval: &duration, forDate: date)
    calendar.rangeOfUnit(.DayCalendarUnit, startDate: &toDate, interval: &duration, forDate: otherDate)
    
    let difference = calendar.components(.DayCalendarUnit, fromDate: fromDate!, toDate: toDate!, options: NSCalendarOptions.allZeros)
    
    return difference.day
}

func addDay(date: NSDate) -> NSDate {
    return date.dateByAddingTimeInterval(60*60*24)
}