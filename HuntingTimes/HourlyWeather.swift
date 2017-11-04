//
//  HourlyWeather.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 12/28/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import Foundation

class HourlyWeather {
    let temperature : Float
    let wind        : Wind
    let pressure    : Pressure
    let time        : Date
    
    init(temperature: Float, windSpeed: Float, windBearing: Float, pressure: Float, at: Date) {
        self.temperature = temperature
        self.wind        = Wind(speed: windSpeed, bearing: windBearing)
        self.pressure    = Pressure(atmospheres: pressure)
        self.time        = at
    }
}
