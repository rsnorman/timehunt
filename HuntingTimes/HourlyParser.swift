//
//  HourlyParser.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 12/28/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import Foundation

class HourlyWeatherParser {
    let hourlyWeather : [HourlyWeather]
    
    init(weatherJSON : [String : AnyObject]) {
        hourlyWeather = []
        
        for hourData in hourlyData(weatherJSON) {
            let temperature: Double = hourData["temperature"] as Double
            let hourTime   : NSDate = NSDate(timeIntervalSince1970: hourData["time"] as NSTimeInterval)
            println("Temperature = \(temperature) at \(hourTime)")
            
            hourlyWeather.append(HourlyWeather(temperature: temperature, at: hourTime))
        }
    }
    
    func onDate(date : NSDate) -> [HourlyWeather] {
        var currentHourlyData: [HourlyWeather] = []
        let dateString = formatDate(date)
        
        for hourWeather in hourlyWeather {
            if dateString == formatDate(hourWeather.time) {
                currentHourlyData.append(hourWeather)
            }
        }
        
        return currentHourlyData
    }
    
    private
    
    func formatDate(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = NSTimeZone()
        return dateFormatter.stringFromDate(date)
    }
    
    func hourlyData(weatherJSON: [String : AnyObject]) -> [[String : AnyObject]] {
        if let hourly = weatherJSON["hourly"] as? [String : AnyObject] {
            return hourly["data"] as [[String : AnyObject]]!
        } else {
            return []
        }
    }
}