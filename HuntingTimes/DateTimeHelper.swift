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
    return calendar.date(bySettingHour: 0, minute: 0, second: 0, of: dateTime)!
}

func isToday(_ date: Date) -> Bool {
    let currentDate = Date()
    return Calendar.current.dateComponents([.day], from: date, to: currentDate).day == 0
}

func differenceInDays(_ date: Date, otherDate: Date) -> Int {
    return Calendar.current.dateComponents([.day], from: date, to: otherDate).day ?? 0
}

func addDay(_ date: Date) -> Date {
    return date.addingTimeInterval(60*60*24)
}
