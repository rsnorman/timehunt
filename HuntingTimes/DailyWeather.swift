//
//  DailyWeather.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 12/28/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import Foundation

class DailyWeather {
    let hourlyWeather : [HourlyWeather]
    let date          : NSDate
    
    init(hourlyWeather: [HourlyWeather], on: NSDate) {
        self.hourlyWeather = hourlyWeather
        self.date          = on
    }
    
    func temperatureAt(time: NSDate) -> Double {
        println("Hourly Weather Count: \(hourlyWeather.count) on: \(time)")
        for hourWeather in hourlyWeather {
            let timeComparison = time.compare(hourWeather.time)
            if timeComparison == NSComparisonResult.OrderedAscending || timeComparison == NSComparisonResult.OrderedSame {
                return hourWeather.temperature
            }
        }
        
        return 0.0
    }
}
