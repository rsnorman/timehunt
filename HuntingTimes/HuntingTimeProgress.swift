//
//  HuntingTimeProgress.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 11/25/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import UIKit

class HuntingTimeProgress {
    var huntingDay         : HuntingDay!
    let huntingTimesColumn : ColumnView
    
    init(huntingTimesColumn: ColumnView) {
        self.huntingTimesColumn = huntingTimesColumn
    }
    
    func getProgressPercent() -> CGFloat {
        let lastTime = getLastTime(Date())
        let nextTime = getNextTime(Date())
        
        if lastTime.event == nextTime.event {
            return huntingDay.dayBeginning.event == lastTime.event ? 0.0 : 1.0
        }
        
        var lastPoint : CGPoint?
        var nextPoint : CGPoint?
        
        if isFirstTime(lastTime.time as Date) {
            lastPoint = CGPoint(x: 0, y: 0)
            nextPoint = huntingTimesColumn.getPosition(nextTime.toTimeString())
        } else if isLastTime(nextTime.time as Date) {
            lastPoint = huntingTimesColumn.getPosition(lastTime.toTimeString())
            nextPoint = CGPoint(x: 0, y: huntingTimesColumn.frame.height)
        } else {
            lastPoint = huntingTimesColumn.getPosition(lastTime.toTimeString())
            nextPoint = huntingTimesColumn.getPosition(nextTime.toTimeString())
        }
        
        let timeSinceNext = nextTime.timeIntervalSinceDate(lastTime.time)
        let timeSinceNow  = Date().timeIntervalSince(lastTime.time as Date)
        
        let percentOfTime = CGFloat(timeSinceNow / timeSinceNext)
        
        if lastPoint != nil && nextPoint != nil {
            let currentPosition = lastPoint!.y + (nextPoint!.y - lastPoint!.y) * percentOfTime
            
            return currentPosition / huntingTimesColumn.frame.height
        } else {
            return 0.0
        }
    }
    
    fileprivate
    
    func getHuntingTimes() -> [HuntingTime] {
        var times = huntingDay.allTimes()
        times.insert(huntingDay.dayBeginning, at: 0)
        times.append(huntingDay.dayEnd)
        
        return times
    }
    
    func isFirstTime(_ time: Date) -> Bool {
        return huntingDay.dayBeginning.time as Date == time
    }
    
    func isLastTime(_ time: Date) -> Bool {
        return huntingDay.dayEnd.time as Date == time
    }
    
    func getLastTime(_ nextTime: Date) -> HuntingTime {
        for time in getHuntingTimes().reversed() {
            if time.timeIntervalSinceDate(nextTime) < 0 {
                return time
            }
        }
        
        return getHuntingTimes().first!
    }
    
    func getNextTime(_ nextTime: Date) -> HuntingTime {
        for time in getHuntingTimes() {
            if time.timeIntervalSinceDate(nextTime) >= 0 {
                return time
            }
        }
        
        return getHuntingTimes().last!
    }
}
