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
        
        guard let hourly = weatherJSON["daily"] else { return }
        guard let dailyDatum = hourly["data"] as? [[String: Any]] else { return }
        guard let sunriseSeconds = dailyDatum[0]["sunriseTime"] else { return }
        guard let sunsetSeconds = dailyDatum[0]["sunsetTime"] else { return }
        
        sunriseTime = Date(timeIntervalSince1970: sunriseSeconds as! TimeInterval)
        sunsetTime  = Date(timeIntervalSince1970: sunsetSeconds as! TimeInterval)
    }
}
