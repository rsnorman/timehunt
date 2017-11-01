//
//  WeatherParser.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 12/28/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import Foundation
import CoreLocation
import ForecastIO

protocol WeatherParserDelegate {
    func weatherReceived()
    func weatherNotReceived()
}

class WeatherParser: NSObject {
    
    let darkSkyClient : DarkSkyClient
    var dailyWeather  : [DailyWeather]!
    var delegate      : WeatherParserDelegate!
    
    class var sharedInstance : WeatherParser {
        struct Static {
            static let instance : WeatherParser = WeatherParser()
        }
        return Static.instance
    }
    
    override init() {
        
        darkSkyClient = DarkSkyClient(apiKey: "8ab15e9dc5a398ed2698ea831d1efb82")
        
        super.init()
    }
    
    func fetch(_ location: CLLocation, date : Date, success: @escaping (DailyWeather) -> (), failure: @escaping () -> ()) {
        let _ = self.formatDate(date) // Use this to get weather for date
        
        darkSkyClient.getForecast(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude) { result in
            
            switch result {
            case .success(let currentForecast, _):
                self.setDailyWeather(forecast: currentForecast)
                success(self.dailyWeather[0])
            case .failure(_):
                failure()
            }
        }
    }
    
    fileprivate
    
//    func parse(_ weatherJSON: [String:AnyObject]) {
//        dailyWeather = []
//        let hourlyWeatherParser = HourlyWeatherParser(weatherJSON: weatherJSON)
//
//        for dayData in dailyData(weatherJSON) {
//            let date = Date(timeIntervalSince1970: dayData["time"] as! TimeInterval)
//            let sunrise = Date(timeIntervalSince1970: dayData["sunriseTime"] as! TimeInterval)
//            let sunset  = Date(timeIntervalSince1970: dayData["sunsetTime"] as! TimeInterval)
//
//            let hourlyWeather = hourlyWeatherParser.onDate(date)
//            var dayWeather : DailyWeather
//
//            if isToday(date) {
//                let currentWeather: [String : AnyObject] = weatherJSON["currently"] as! [String : AnyObject]
//                dayWeather = DailyWeather(currentWeather: currentWeather, hourlyWeather: hourlyWeather, on: date)
//            } else {
//                dayWeather = DailyWeather(currentWeather: dayData, hourlyWeather: hourlyWeather, on: date)
//            }
//
//            dayWeather.sunrise = sunrise
//            dayWeather.sunset = sunset
//
//            dailyWeather.append(dayWeather)
//        }
//    }
    
    func setDailyWeather(forecast: Forecast) {
        dailyWeather = []
        let hourlyWeatherParser = HourlyWeatherParser(hourlyWeatherData: forecast.hourly!.data)

        for dailyData in forecast.daily!.data {
            let date = dailyData.time
            let sunrise = dailyData.sunriseTime
            let sunset = dailyData.sunsetTime
            var dayWeather: DailyWeather
            let hourlyWeather = hourlyWeatherParser.onDate(date)
            
            dayWeather = DailyWeather(on: date)
            dayWeather.hourlyWeather = hourlyWeather
            dayWeather.sunrise = sunrise
            dayWeather.sunset = sunset
            
            if isToday(date) {
                dayWeather.currentWeather = forecast.currently
            } else {
                dayWeather.predictedWeather = dailyData
            }
            
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
