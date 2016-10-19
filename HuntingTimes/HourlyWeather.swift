//
//  HourlyWeather.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 12/28/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import Foundation

class HourlyWeather {
    let temperature : Double
    let time        : Date
    
    init(temperature: Double, at: Date) {
        self.temperature = temperature
        self.time        = at
    }
}
