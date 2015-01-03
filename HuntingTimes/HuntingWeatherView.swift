//
//  HuntingWeatherView.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 12/11/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import UIKit

class HuntingWeatherView : UIView {
    var weatherColumnView : ColumnView!
    let timeColumnView    : ColumnView
    let padding           : CGFloat = 15
    var huntingDay        : HuntingDay!
    
    override init(frame: CGRect) {
        timeColumnView = ColumnView(labels: [], frame: CGRectMake(0, 0, frame.width / 2.0 - padding, frame.height))
        timeColumnView.setTextAlignment(NSTextAlignment.Right)
        
        super.init(frame: frame)
        
        addSubview(timeColumnView)
    }
    
    func setDay(huntingDay: HuntingDay) {
        self.huntingDay = huntingDay
        timeColumnView.setLabels([huntingDay.startTime.toTimeString(), huntingDay.sunriseTime.toTimeString(), huntingDay.sunsetTime.toTimeString(), huntingDay.endTime.toTimeString()])
        
        setTemperatures(huntingDay.weather)
    }
    
    
    func setTemperatures(dailyWeather: DailyWeather) {
        let temperatures = ["\(Int(round(dailyWeather.temperatureAt(huntingDay.startTime.time))))°",
            "\(Int(round(dailyWeather.temperatureAt(huntingDay.sunriseTime.time))))°",
            "\(Int(round(dailyWeather.temperatureAt(huntingDay.sunsetTime.time))))°",
            "\(Int(round(dailyWeather.temperatureAt(huntingDay.endTime.time))))°"]
        
        if weatherColumnView != nil {
            weatherColumnView.removeFromSuperview()
        }
        
        weatherColumnView = ColumnView(labels: temperatures, frame: CGRectMake(frame.width / 2.0 + padding, 0, frame.width / 2.0 - padding, frame.height))
        weatherColumnView.setTextAlignment(NSTextAlignment.Left)
        addSubview(weatherColumnView)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
