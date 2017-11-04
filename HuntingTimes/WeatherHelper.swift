//
//  WeatherHelper.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 11/4/17.
//  Copyright © 2017 Ryan Norman. All rights reserved.
//

import Foundation

func windToString(_ wind: Wind, full: Bool = true) -> String {
    let direction : String
    if wind.bearing < 22.5 {
        direction = "E"
    } else if wind.bearing < 67.5 {
        direction = "NE"
    } else if wind.bearing < 112.5 {
        direction = "N"
    } else if wind.bearing < 157.5 {
        direction = "NW"
    } else if wind.bearing < 202.5 {
        direction = "W"
    } else if wind.bearing < 247.5 {
        direction = "SW"
    } else if wind.bearing < 292.5 {
        direction = "S"
    } else if wind.bearing < 337.5 {
        direction = "SE"
    } else {
        direction = "E"
    }

    if full {
        return "\(Int(round(wind.speed))) mph (\(direction))"
    } else {
        return "\(Int(round(wind.speed))) \(direction)"
    }
}

func pressureToString(_ pressure: Pressure) -> String {
    return "\(Int(round(pressure.atmospheres))) mb"
}
