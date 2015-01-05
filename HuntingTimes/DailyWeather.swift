//
//  DailyWeather.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 12/28/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import Foundation

class DailyWeather {
    let currentWeather : [String : AnyObject]
    let hourlyWeather  : [HourlyWeather]
    let date           : NSDate
    
    init(currentWeather: [String: AnyObject], hourlyWeather: [HourlyWeather], on: NSDate) {
        self.currentWeather = currentWeather
        self.hourlyWeather  = hourlyWeather
        self.date           = on
    }
    
    func temperatureAt(time: NSDate) -> Double {
        for hourWeather in hourlyWeather {
            let timeComparison = time.compare(hourWeather.time)
            if timeComparison == NSComparisonResult.OrderedAscending || timeComparison == NSComparisonResult.OrderedSame {
                return hourWeather.temperature
            }
        }
        
        return 0.0
    }
    
    func hasCurrent() -> Bool {
        return isToday(date)
    }
    
    func currentTemperature() -> Int {
        return Int(round(currentWeather["temperature"] as Double))
    }
    
    func lowTemperature() -> Int {
        return Int(round(currentWeather["temperatureMin"] as Double))
    }
    
    func highTemperature() -> Int {
        return Int(round(currentWeather["temperatureMax"] as Double))
    }
}
