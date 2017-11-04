//
//  DailyWeather.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 12/28/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import Foundation
import ForecastIO

class DailyWeather {
    var currentWeather : DataPoint!
    var predictedWeather: DataPoint!
    var hourlyWeather  : [HourlyWeather]!
    let date           : Date
    var sunrise        : Date!
    var sunset         : Date!
    
    init(on: Date) {
        self.date = on
    }
    
    func temperatureAt(_ time: Date) -> Float {
        for hourWeather in hourlyWeather {
            let timeComparison = time.compare(hourWeather.time as Date)
            if timeComparison == ComparisonResult.orderedAscending || timeComparison == ComparisonResult.orderedSame {
                return hourWeather.temperature
            }
        }
        
        return 0.0
    }
    
    func hasCurrent() -> Bool {
        return currentWeather != nil
    }
    
    func currentTemperature() -> Int {
        guard let temperature = currentWeather!.temperature else {
            return 0
        }
        return Int(temperature)
    }

    func currentWindSpeed() -> Int {
        guard let windSpeed = currentWeather!.windSpeed else {
            return 0
        }
        return Int(windSpeed)
    }

    func currentWindBearing() -> Int {
        guard let windBearing = currentWeather!.windBearing else {
            return 0
        }
        return Int(windBearing)
    }

    func predictedWindSpeed() -> Int {
        guard let windSpeed = predictedWeather!.windSpeed else {
            return 0
        }
        return Int(round(windSpeed))
    }

    func predictedWindBearing() -> Int {
        guard let windBearing = predictedWeather!.windBearing else {
            return 0
        }
        return Int(round(windBearing))
    }

    func lowTemperature() -> Int {
        guard let lowTemp = predictedWeather!.temperatureMin else {
            return 0
        }
        return Int(round(lowTemp))
    }
    
    func highTemperature() -> Int {
        guard let highTemp = predictedWeather!.temperatureMax else {
            return 0
        }
        return Int(round(highTemp))
    }
}
