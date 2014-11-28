//
//  HuntingTime.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 11/28/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import Foundation

struct HuntingTime {
    let time  : NSDate
    let event : String
    
    init(time: NSDate, event: String) {
        self.time  = time
        self.event = event
    }
    
    func timeIntervalSinceNow() -> NSTimeInterval {
        return self.time.timeIntervalSinceNow
    }
    
    func timeIntervalSinceDate(date: NSDate) -> NSTimeInterval {
        return time.timeIntervalSinceDate(date)
    }
    
    func toTimeString() -> String {
        return timeToString(time)
    }
    
    func toDateString() -> String {
        return dateToString(time)
    }
}