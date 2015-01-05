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
        let dateString = formatDate(date)
        
        forecastr.getForecastForLocation(location, time: NSNumber(double: date.timeIntervalSince1970), exclusions: nil, extend: nil, language: nil, success: { (json) -> Void in
            self.parse(json as [String: AnyObject])
            
            for dayWeather in self.dailyWeather {
                if dateString == self.formatDate(dayWeather.date) {
                    success(dayWeather)
                }
            }
            
            
        }) { (error, message) -> Void in
            println(error)
            println(message)
            
            failure()
        }
    }
    
    private
    
    func parse(weatherJSON: [String:AnyObject]) {
        dailyWeather = []
        let hourlyWeatherParser = HourlyWeatherParser(weatherJSON: weatherJSON)
        for dayData in dailyData(weatherJSON) {
            let date = NSDate(timeIntervalSince1970: dayData["time"] as NSTimeInterval)
            let hourlyWeather = hourlyWeatherParser.onDate(date)
            if isToday(date) {
                let currentWeather: [String : AnyObject] = weatherJSON["currently"] as [String : AnyObject]
                dailyWeather.append(DailyWeather(currentWeather: currentWeather, hourlyWeather: hourlyWeather, on: date))
            } else {
                dailyWeather.append(DailyWeather(currentWeather: dayData, hourlyWeather: hourlyWeather, on: date))
            }
        }
    }
    
    func formatDate(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = NSTimeZone()
        return dateFormatter.stringFromDate(date)
    }
    
    func dailyData(weatherJSON: [String : AnyObject]) -> [[String : AnyObject]] {
        if let daily = weatherJSON["daily"] as? [String : AnyObject] {
            return daily["data"] as [[String : AnyObject]]!
        } else {
            return []
        }
    }
}