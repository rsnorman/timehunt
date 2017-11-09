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
    
    func windAt(_ time: Date) -> Wind {
        for hourWeather in hourlyWeather {
            let timeComparison = time.compare(hourWeather.time as Date)
            if timeComparison == ComparisonResult.orderedAscending || timeComparison == ComparisonResult.orderedSame {
                return hourWeather.wind
            }
        }
        
        return Wind(speed: 0, bearing: 0)
    }
    
    func pressureAt(_ time: Date) -> Pressure {
        for hourWeather in hourlyWeather {
            let timeComparison = time.compare(hourWeather.time as Date)
            if timeComparison == ComparisonResult.orderedAscending || timeComparison == ComparisonResult.orderedSame {
                return hourWeather.pressure
            }
        }
        
        return Pressure(atmospheres: 0)
    }
    
    func hasCurrent() -> Bool {
        return currentWeather != nil && isToday(date)
    }
    
    func currentTemperature() -> Int {
        guard let temperature = currentWeather!.temperature else {
            return 0
        }
        return Int(temperature)
    }

    func currentWind() -> Wind {
        guard let windSpeed = currentWeather!.windSpeed, let windBearing = currentWeather!.windBearing else {
            return Wind(speed: 0, bearing: 0)
        }
        return Wind(speed: windSpeed, bearing: windBearing)
    }

    func predictedWind() -> Wind {
        guard let windSpeed = predictedWeather!.windSpeed, let windBearing = predictedWeather!.windBearing else {
            return Wind(speed: 0, bearing: 0)
        }
        return Wind(speed: windSpeed, bearing: windBearing)
    }
    
    func currentPressure() -> Pressure {
        guard let pressure = currentWeather!.pressure else {
            return Pressure(atmospheres: 0)
        }
        return Pressure(atmospheres: pressure)
    }
    
    func predictedPressure() -> Pressure {
        guard let pressure = predictedWeather!.pressure else {
            return Pressure(atmospheres: 0)
        }
        return Pressure(atmospheres: pressure)
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
