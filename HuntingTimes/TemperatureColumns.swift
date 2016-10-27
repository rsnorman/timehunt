//
//  HuntingWeatherView.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 12/11/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import UIKit

class TemperatureColumns : HuntingColumnsView {

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    required init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func setDay(_ huntingDay: HuntingDay) {
        super.setDay(huntingDay)
        
        leftColumnView.setLabels([huntingDay.startTime.toTimeString(), huntingDay.sunriseTime.toTimeString(), huntingDay.sunsetTime.toTimeString(), huntingDay.endTime.toTimeString()])
        
        setTemperatures(huntingDay.weather)
    }
    
    
    func setTemperatures(_ dailyWeather: DailyWeather) {
        let temperatures = [temperatureString(for: dailyWeather, at: huntingDay.startTime),
                            temperatureString(for: dailyWeather, at: huntingDay.sunriseTime),
                            temperatureString(for: dailyWeather, at: huntingDay.sunsetTime),
                            temperatureString(for: dailyWeather, at: huntingDay.endTime)]
        
        rightColumnView.setLabels(temperatures)
    }
    
    func temperatureString(for dailyWeather: DailyWeather, at huntingTime: HuntingTime) -> String {
        return "\(Int(round(dailyWeather.temperatureAt(huntingTime.time))))°"
    }
}
