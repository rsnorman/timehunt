//
//  HuntingTimeProgress.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 11/25/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import UIKit

class HuntingTimeProgress {
    var huntingTimes       : [NSDate]
    let huntingTimesColumn : ColumnView
    
    init(huntingTimes: [NSDate], huntingTimesColumn: ColumnView) {
        self.huntingTimes = huntingTimes
        self.huntingTimesColumn = huntingTimesColumn
    }
    
    func getProgressPercent() -> CGFloat {
        let lastTime = getLastTime(NSDate())
        let nextTime = getNextTime(NSDate())
        
        if lastTime == nextTime {
            return 0.0
        }
        
        var lastPoint : CGPoint?
        var nextPoint : CGPoint?
        
        if isFirstTime(lastTime) {
            lastPoint = CGPointMake(0, 0)
            nextPoint = huntingTimesColumn.getPosition(timeToString(nextTime))
        } else if isLastTime(nextTime) {
            lastPoint = huntingTimesColumn.getPosition(timeToString(lastTime))
            nextPoint = CGPointMake(0, huntingTimesColumn.frame.height)
        } else {
            lastPoint = huntingTimesColumn.getPosition(timeToString(lastTime))
            nextPoint = huntingTimesColumn.getPosition(timeToString(nextTime))
        }
        
        let timeSinceNext = nextTime.timeIntervalSinceDate(lastTime)
        let timeSinceNow  = NSDate().timeIntervalSinceDate(lastTime)
        
        let percentOfTime = CGFloat(timeSinceNow / timeSinceNext)
        
        let currentPosition = lastPoint!.y + (nextPoint!.y - lastPoint!.y) * percentOfTime
        
        return currentPosition / huntingTimesColumn.frame.height
    }
    
    private
    
    func getHuntingTimes() -> [NSDate] {
        let calendar = NSCalendar.currentCalendar()
        let dayStart = calendar.dateBySettingHour(0, minute: 0, second: 0, ofDate: huntingTimes[0], options: nil)
        let dayEnd   = calendar.dateBySettingHour(23, minute: 59, second: 59, ofDate: huntingTimes[0], options: nil)
        return [dayStart!, huntingTimes[0], huntingTimes[1], huntingTimes[2], huntingTimes[3], dayEnd!]
    }
    
    func isFirstTime(time: NSDate) -> Bool {
        return getHuntingTimes()[0] == time
    }
    
    func isLastTime(time: NSDate) -> Bool {
        return getHuntingTimes().last == time
    }
    
    func getLastTime(nextTime: NSDate) -> NSDate {
        for time in getHuntingTimes().reverse() {
            if time.timeIntervalSinceDate(nextTime) < 0 {
                return time
            }
        }
        
        return getHuntingTimes().first!
    }
    
    func getNextTime(nextTime: NSDate) -> NSDate {
        for time in getHuntingTimes() {
            if time.timeIntervalSinceDate(nextTime) >= 0 {
                return time
            }
        }
        
        return getHuntingTimes().last!
    }
}
