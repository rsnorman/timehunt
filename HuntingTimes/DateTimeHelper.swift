//
//  DateTimeHelper.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 11/26/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import Foundation

func dateToString(_ dateTime: Date, useRelativeString: Bool = true) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMMM d"
    let dateString = dateFormatter.string(from: dateTime)
    
    if useRelativeString {
        let today       = clearTime(Date())
        let compareDate = clearTime(dateTime)
        if dateFormatter.string(from: today) == dateString {
            return "Today"
        } else if compareDate.timeIntervalSince(today) < 0 && compareDate.timeIntervalSince(today) >= -60 * 60 * 24 {
            return "Yesterday"
        } else if compareDate.timeIntervalSince(today) > 0 && compareDate.timeIntervalSince(today) <= 60 * 60 * 24 {
            return "Tomorrow"
        }
    }
    
    return dateString
}

func timeToString(_ dateTime: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "h:mm"
    
    return dateFormatter.string(from: dateTime)
}

func clearTime(_ dateTime: Date) -> Date {
    let calendar = Calendar.current
    return calendar.dateBySettingHour(0, minute: 0, second: 0, ofDate: dateTime, options: nil)!
}

func isToday(_ date: Date) -> Bool {
    let cal = Calendar.current
    var components = cal.components((NSCalendar.Unit.CalendarUnitEra|NSCalendar.Unit.CalendarUnitYear|NSCalendar.Unit.CalendarUnitMonth|NSCalendar.Unit.CalendarUnitDay), fromDate: Date())
    let today = cal.dateFromComponents(components)
    components = cal.components((NSCalendar.Unit.CalendarUnitEra|NSCalendar.Unit.CalendarUnitYear|NSCalendar.Unit.CalendarUnitMonth|NSCalendar.Unit.CalendarUnitDay), fromDate: date)
    let otherDate = cal.dateFromComponents(components)
    
    return today!.isEqualToDate(otherDate!)
}

func differenceInDays(_ date: Date, otherDate: Date) -> Int {
    let calendar = Calendar.current
    var fromDate : Date?
    var toDate   : Date?
    var duration : TimeInterval = 0
    
    calendar.rangeOfUnit(.DayCalendarUnit, startDate: &fromDate, interval: &duration, forDate: date)
    calendar.rangeOfUnit(.DayCalendarUnit, startDate: &toDate, interval: &duration, forDate: otherDate)
    
    let difference = calendar.components(.DayCalendarUnit, fromDate: fromDate!, toDate: toDate!, options: NSCalendar.Options.allZeros)
    
    return difference.day
}

func addDay(_ date: Date) -> Date {
    return date.addingTimeInterval(60*60*24)
}
