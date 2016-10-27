//
//  WeatherParser.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 12/28/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import Foundation

protocol WeatherParserDelegate {
    func weatherReceived()
    func weatherNotReceived()
}

class WeatherParser: NSObject {
    
    let forecastr    : Forecastr
    var dailyWeather : [DailyWeather]!
    var delegate     : WeatherParserDelegate!
    
    class var sharedInstance : WeatherParser {
        struct Static {
            static let instance : WeatherParser = WeatherParser()
        }
        return Static.instance
    }
    
    override init() {
        
        forecastr = Forecastr.sharedManager() as! Forecastr
        forecastr.apiKey = "8ab15e9dc5a398ed2698ea831d1efb82"
        
        super.init()
    }
    
    func fetch(_ location: CLLocation, date : Date, success: @escaping (DailyWeather) -> (), failure: @escaping () -> ()) {
        let dateString = self.formatDate(date)
        
        forecastr.getForecastFor(location, time: NSNumber(value: date.timeIntervalSince1970 as Double), exclusions: nil, extend: nil, language: nil, success: { (json) -> Void in
            self.parse(json as! [String: AnyObject])
            
            for dayWeather in self.dailyWeather {
                if dateString == self.formatDate(dayWeather.date as Date) {
                    success(dayWeather)
                } else {
                    failure()
                }
            }
            
            
        }) { (error, message) -> Void in
            failure()
        }
    }
    
    fileprivate
    
    func parse(_ weatherJSON: [String:AnyObject]) {
        dailyWeather = []
        let hourlyWeatherParser = HourlyWeatherParser(weatherJSON: weatherJSON)
        
        for dayData in dailyData(weatherJSON) {
            let date = Date(timeIntervalSince1970: dayData["time"] as! TimeInterval)
            let sunrise = Date(timeIntervalSince1970: dayData["sunriseTime"] as! TimeInterval)
            let sunset  = Date(timeIntervalSince1970: dayData["sunsetTime"] as! TimeInterval)
            
            let hourlyWeather = hourlyWeatherParser.onDate(date)
            var dayWeather : DailyWeather
            
            if isToday(date) {
                let currentWeather: [String : AnyObject] = weatherJSON["currently"] as! [String : AnyObject]
                dayWeather = DailyWeather(currentWeather: currentWeather, hourlyWeather: hourlyWeather, on: date)
            } else {
                dayWeather = DailyWeather(currentWeather: dayData, hourlyWeather: hourlyWeather, on: date)
            }
            
            dayWeather.sunrise = sunrise
            dayWeather.sunset = sunset
            
            dailyWeather.append(dayWeather)
        }
    }
    
    func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = NSTimeZone.local
        return dateFormatter.string(from: clearTime(date))
    }
    
    func dailyData(_ weatherJSON: [String : AnyObject]) -> [[String : AnyObject]] {
        if let daily = weatherJSON["daily"] as? [String : AnyObject] {
            return daily["data"] as! [[String : AnyObject]]!
        } else {
            return []
        }
    }
}
