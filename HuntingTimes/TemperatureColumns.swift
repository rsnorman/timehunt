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
        let temperatures = ["\(Int(round(dailyWeather.temperatureAt(huntingDay.startTime.time))))°",
            "\(Int(round(dailyWeather.temperatureAt(huntingDay.sunriseTime.time))))°",
            "\(Int(round(dailyWeather.temperatureAt(huntingDay.sunsetTime.time))))°",
            "\(Int(round(dailyWeather.temperatureAt(huntingDay.endTime.time))))°"]
        
        rightColumnView.setLabels(temperatures)
    }
}
