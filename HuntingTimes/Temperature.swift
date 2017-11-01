//
//  Temperature.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 12/28/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import Foundation

class TemperatureParser {
    let dailyTemperature   : Double
    let hourlyTemperatures : [Double]
    
    
    init(weatherJSON : [String : AnyObject]) {
        dailyTemperature   = 0.0
        hourlyTemperatures = []
        
        for _ in hourlyData(weatherJSON) {
            // println(hourData)
        }
    }
    
    fileprivate
    
    func hourlyData(_ weatherJSON: [String : AnyObject]) -> [[String : AnyObject]] {
        if let hourly = weatherJSON["hourly"] as? [String : AnyObject] {
            return hourly["data"] as! [[String : AnyObject]]!
        } else {
            return []
        }
    }
}
