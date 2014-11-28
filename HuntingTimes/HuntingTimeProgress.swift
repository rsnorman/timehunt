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
        
        if lastTime.event == nextTime.event {
            return huntingDay.dayBeginning.event == lastTime.event ? 0.0 : 1.0
        }
        
        var lastPoint : CGPoint?
        var nextPoint : CGPoint?
        
        if isFirstTime(lastTime.time) {
            lastPoint = CGPointMake(0, 0)
            nextPoint = huntingTimesColumn.getPosition(nextTime.toTimeString())
        } else if isLastTime(nextTime.time) {
            lastPoint = huntingTimesColumn.getPosition(lastTime.toTimeString())
            nextPoint = CGPointMake(0, huntingTimesColumn.frame.height)
        } else {
            lastPoint = huntingTimesColumn.getPosition(lastTime.toTimeString())
            nextPoint = huntingTimesColumn.getPosition(nextTime.toTimeString())
        }
        
        let timeSinceNext = nextTime.timeIntervalSinceDate(lastTime.time)
        let timeSinceNow  = NSDate().timeIntervalSinceDate(lastTime.time)
        
        let percentOfTime = CGFloat(timeSinceNow / timeSinceNext)
        
        if lastPoint != nil && nextPoint != nil {
            let currentPosition = lastPoint!.y + (nextPoint!.y - lastPoint!.y) * percentOfTime
            
            return currentPosition / huntingTimesColumn.frame.height
        } else {
            return 0.0
        }
    }
    
    private
    
    func getHuntingTimes() -> [HuntingTime] {
        var times = huntingDay.allTimes()
        times.insert(huntingDay.dayBeginning, atIndex: 0)
        times.append(huntingDay.dayEnd)
        
        return times
    }
    
    func isFirstTime(time: NSDate) -> Bool {
        return huntingDay.dayBeginning.time == time
    }
    
    func isLastTime(time: NSDate) -> Bool {
        return huntingDay.dayEnd.time == time
    }
    
    func getLastTime(nextTime: NSDate) -> HuntingTime {
        for time in getHuntingTimes().reverse() {
            if time.timeIntervalSinceDate(nextTime) < 0 {
                return time
            }
        }
        
        return getHuntingTimes().first!
    }
    
    func getNextTime(nextTime: NSDate) -> HuntingTime {
        for time in getHuntingTimes() {
            if time.timeIntervalSinceDate(nextTime) >= 0 {
                return time
            }
        }
        
        return getHuntingTimes().last!
    }
}
