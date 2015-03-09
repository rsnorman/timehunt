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
        
        forecastr = Forecastr.sharedManager() as Forecastr
        forecastr.apiKey = "8ab15e9dc5a398ed2698ea831d1efb82"
        
        super.init()
    }
    
    func fetch(location: CLLocation, date : NSDate, success: (DailyWeather) -> (), failure: () -> ()) {
        var currentHourlyData: [HourlyWeather] = []
        let dateString = self.formatDate(date)
        
        forecastr.getForecastForLocation(location, time: NSNumber(double: date.timeIntervalSince1970), exclusions: nil, extend: nil, language: nil, success: { (json) -> Void in
            self.parse(json as [String: AnyObject])
            
            for dayWeather in self.dailyWeather {
                if dateString == self.formatDate(dayWeather.date) {
                    success(dayWeather)
                } else {
                    failure()
                }
            }
            
            
        }) { (error, message) -> Void in
            failure()
        }
    }
    
    private
    
    func parse(weatherJSON: [String:AnyObject]) {
        dailyWeather = []
        let hourlyWeatherParser = HourlyWeatherParser(weatherJSON: weatherJSON)
        
        for dayData in dailyData(weatherJSON) {
            let date = NSDate(timeIntervalSince1970: dayData["time"] as NSTimeInterval)
            let sunrise = NSDate(timeIntervalSince1970: dayData["sunriseTime"] as NSTimeInterval)
            let sunset  = NSDate(timeIntervalSince1970: dayData["sunsetTime"] as NSTimeInterval)
            
            let hourlyWeather = hourlyWeatherParser.onDate(date)
            var dayWeather : DailyWeather
            
            if isToday(date) {
                let currentWeather: [String : AnyObject] = weatherJSON["currently"] as [String : AnyObject]
                dayWeather = DailyWeather(currentWeather: currentWeather, hourlyWeather: hourlyWeather, on: date)
            } else {
                dayWeather = DailyWeather(currentWeather: dayData, hourlyWeather: hourlyWeather, on: date)
            }
            
            dayWeather.sunrise = sunrise
            dayWeather.sunset = sunset
            
            dailyWeather.append(dayWeather)
        }
    }
    
    func formatDate(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = NSTimeZone()
        return dateFormatter.stringFromDate(clearTime(date))
    }
    
    func dailyData(weatherJSON: [String : AnyObject]) -> [[String : AnyObject]] {
        if let daily = weatherJSON["daily"] as? [String : AnyObject] {
            return daily["data"] as [[String : AnyObject]]!
        } else {
            return []
        }
    }
}