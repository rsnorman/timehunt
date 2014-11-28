//
//  HuntingTimeParser.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 11/22/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import UIKit

class HuntingSeason {
    let dates           : [HuntingDay]
    var currentPosition : Int!
    
    init() {
        let path = NSBundle.mainBundle().pathForResource("hunting-times", ofType: "csv")
        
        let timesCSV = NSString(contentsOfFile: path!, encoding: NSUTF8StringEncoding, error: nil)
        dates = []
        
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "YYYY-MM-d h:mm a"
        
        for dateLine in timesCSV?.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet()) as [String] {
            let cells = dateLine.componentsSeparatedByString(",")
            
            let startTime = timeFormatter.dateFromString("\(cells[0]) \(cells[1]) AM")!
            let endTime = timeFormatter.dateFromString("\(cells[0]) \(cells[2]) PM")!
            
            dates.append(HuntingDay(startTime: startTime, endTime: endTime))
        }
        
        self.currentPosition = getCurrentPosition()
        
    }
    
    func allDays() -> [HuntingDay] {
        return dates
    }
    
    func length() -> Int {
        return dates.count
    }
    
    func currentDay() -> HuntingDay {
        return dates[currentPosition]
    }
    
    func nextDay() -> HuntingDay {
        currentPosition = currentPosition + 1
        return currentDay()
    }
    
    func previousDay() -> HuntingDay {
        currentPosition = currentPosition - 1
        return currentDay()
    }
    
    func openingDay() -> Bool {
        return currentPosition == 0
    }
    
    func closingDay() -> Bool {
        return currentPosition == dates.count - 1
    }
    
    func setCurrentDay(currentDay: Int) {
        currentPosition = currentDay
    }
    
    func percentComplete() -> CGFloat {
        return CGFloat(currentPosition) / CGFloat(dates.count)
    }
    
    private
    
    func getCurrentPosition() -> Int {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-d"
        let today = dateFormatter.stringFromDate(NSDate())
        
        if dates[0].startTime.timeIntervalSinceNow > 0 {
            return 0
        } else if dates.last?.endTime.timeIntervalSinceNow > 0 {
            for (index, huntingDay) in enumerate(dates) {
                if today == dateFormatter.stringFromDate(huntingDay.startTime) {
                    return index
                }
            }
        }
        
        return dates.count - 1
    }
}
