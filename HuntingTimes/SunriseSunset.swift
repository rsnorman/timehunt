//
//  SunriseSunset.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 12/25/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import Foundation

class SunriseSunset {
    let sunriseTime : NSDate
    let sunsetTime  : NSDate
    
    init(weatherJSON : [String : AnyObject]) {
        sunriseTime = NSDate(timeIntervalSince1970: 0)
        sunsetTime  = NSDate(timeIntervalSince1970: 0)
        
        if let hourly = weatherJSON["daily"] as? [String : AnyObject] {
            if let dailyData = hourly["data"] as? [[String : AnyObject]] {
                let sunriseSeconds: NSTimeInterval = dailyData[0]["sunriseTime"] as NSTimeInterval
                let sunsetSeconds: NSTimeInterval  = dailyData[0]["sunsetTime"] as NSTimeInterval
                
                sunriseTime = NSDate(timeIntervalSince1970: sunriseSeconds)
                sunsetTime  = NSDate(timeIntervalSince1970: sunsetSeconds)
            }
        }
    }
}
