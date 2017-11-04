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
        darkSkyClient.getForecast(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, time: date) { result in
            
            switch result {
            case .success(let currentForecast, _):
                self.setDailyWeather(date: date, forecast: currentForecast)
                success(self.dailyWeather[0])
            case .failure(_):
                failure()
            }
        }
    }
    
    fileprivate
    
    func setDailyWeather(date: Date, forecast: Forecast) {
        dailyWeather = []
        guard let hourlyForecast = forecast.hourly else { return }
        guard let dailyForecast = forecast.daily else { return }

        let hourlyWeatherParser = HourlyWeatherParser(hourlyWeatherData: hourlyForecast.data)

        for dailyData in dailyForecast.data {
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
        guard let daily = weatherJSON["daily"] as? [String : AnyObject] else { return [] }
        return daily["data"] as! [[String : AnyObject]]
    }
}
