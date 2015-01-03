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
    let time        : NSDate
    
    init(temperature: Double, at: NSDate) {
        self.temperature = temperature
        self.time        = at
    }
}