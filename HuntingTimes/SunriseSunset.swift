//
//  SunriseSunset.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 12/25/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import Foundation

class SunriseSunset {
    var sunriseTime : Date
    var sunsetTime  : Date
    
    init(weatherJSON : [String : AnyObject]) {
        sunriseTime = Date(timeIntervalSince1970: 0)
        sunsetTime  = Date(timeIntervalSince1970: 0)
        
        if let hourly = weatherJSON["daily"] as? [String : AnyObject] {
            if let dailyData = hourly["data"] as? [[String : AnyObject]] {
                let sunriseSeconds: TimeInterval = dailyData[0]["sunriseTime"] as! TimeInterval
                let sunsetSeconds: TimeInterval  = dailyData[0]["sunsetTime"] as! TimeInterval
                
                sunriseTime = Date(timeIntervalSince1970: sunriseSeconds)
                sunsetTime  = Date(timeIntervalSince1970: sunsetSeconds)
            }
        }
    }
}
