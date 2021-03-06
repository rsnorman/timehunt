//
//  HourlyParser.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 12/28/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import Foundation
import ForecastIO

class HourlyWeatherParser {
    let hourlyWeather : [HourlyWeather]
    
    init(hourlyWeatherData : [DataPoint]) {
        var weather: [HourlyWeather] = []
        
        for hourData in hourlyWeatherData {
            let hourTime = hourData.time
            guard let temperature = hourData.temperature, let windSpeed = hourData.windSpeed, let windBearing = hourData.windBearing, let pressure = hourData.pressure else {
                weather.append(HourlyWeather(temperature: 0.0, windSpeed: 0.0, windBearing: 0.0, pressure: 0.0, at: hourTime))
                continue
            }
            weather.append(HourlyWeather(temperature: temperature, windSpeed: windSpeed, windBearing: windBearing, pressure: pressure, at: hourTime))
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
