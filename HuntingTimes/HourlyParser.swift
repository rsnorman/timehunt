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
        var weather: [HourlyWeather] = []
        
        for hourData in HourlyWeatherParser.hourlyData(weatherJSON) {
            let temperature: Double = hourData["temperature"] as! Double
            let hourTime   : Date = Date(timeIntervalSince1970: hourData["time"] as! TimeInterval)
            
            weather.append(HourlyWeather(temperature: temperature, at: hourTime))
        }
        
        hourlyWeather = weather
    }
    
    func onDate(_ date : Date) -> [HourlyWeather] {
        var currentHourlyData: [HourlyWeather] = []
        let dateString = formatDate(date)
        
        for hourWeather in hourlyWeather {
            if dateString == formatDate(hourWeather.time as Date) {
                currentHourlyData.append(hourWeather)
            }
        }
        
        return currentHourlyData
    }
    
    fileprivate
    
    func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone.ReferenceType.local
        return dateFormatter.string(from: date)
    }
    
    class func hourlyData(_ weatherJSON: [String : AnyObject]) -> [[String : AnyObject]] {
        if let hourly = weatherJSON["hourly"] as? [String : AnyObject] {
            return hourly["data"] as! [[String : AnyObject]]!
        } else {
            return []
        }
    }
}
