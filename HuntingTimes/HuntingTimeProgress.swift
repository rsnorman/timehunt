//
//  HuntingTimeProgress.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 11/25/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import UIKit

class HuntingTimeProgress {
    var huntingDay         : HuntingDay
    let huntingTimesColumn : ColumnView
    
    init(huntingDay: HuntingDay, huntingTimesColumn: ColumnView) {
        self.huntingDay = huntingDay
        self.huntingTimesColumn = huntingTimesColumn
    }
    
    func getProgressPercent() -> CGFloat {
        let lastTime = getLastTime(NSDate())
        let nextTime = getNextTime(NSDate())
        
        if lastTime == nextTime {
            return isFirstTime(lastTime) ? 0.0 : 1.0
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
        var times = huntingDay.allTimes()
        times.insert(huntingDay.getBeginningOfDay(), atIndex: 0)
        times.append(huntingDay.getEndOfDay())
        
        return times
    }
    
    func isFirstTime(time: NSDate) -> Bool {
        return huntingDay.getBeginningOfDay() == time
    }
    
    func isLastTime(time: NSDate) -> Bool {
        return huntingDay.getEndOfDay() == time
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
