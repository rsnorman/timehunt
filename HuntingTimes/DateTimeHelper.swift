//
//  DateTimeHelper.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 11/26/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import Foundation

func dateToString(dateTime: NSDate) -> String {
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "MMMM d"
    let dateString = dateFormatter.stringFromDate(dateTime)
    
    if dateFormatter.stringFromDate(NSDate()) == dateString {
        return "Today"
    } else if dateTime.timeIntervalSinceNow < 0 && dateTime.timeIntervalSinceNow > -60 * 60 * 24 {
        return "Yesterday"
    } else if dateTime.timeIntervalSinceNow > 0 && dateTime.timeIntervalSinceNow < 60 * 60 * 24 {
        return "Tomorrow"
    }
    
    return dateString
}

func timeToString(dateTime: NSDate) -> String {
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "h:mm"
    
    return dateFormatter.stringFromDate(dateTime)
}