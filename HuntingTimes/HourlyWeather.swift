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
    let windSpeed   : Float
    let windBearing : Float
    let time        : Date
    
    init(temperature: Float, windSpeed: Float, windBearing: Float, at: Date) {
        self.temperature = temperature
        self.windSpeed   = windSpeed
        self.windBearing = windBearing
        self.time        = at
    }
}
