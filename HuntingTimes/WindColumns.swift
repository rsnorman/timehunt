//
//  WindColumns.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 11/4/17.
//  Copyright © 2017 Ryan Norman. All rights reserved.
//

import UIKit

class WindColumns : HuntingColumnsView {
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func setDay(_ huntingDay: HuntingDay) {
        super.setDay(huntingDay)
        
        leftColumnView.setLabels([huntingDay.startTime.toTimeString(), huntingDay.sunriseTime.toTimeString(), huntingDay.sunsetTime.toTimeString(), huntingDay.endTime.toTimeString()])
        
        setWinds(huntingDay.weather)
    }
    
    
    func setWinds(_ dailyWeather: DailyWeather) {
        let winds = ["\(Int(round(dailyWeather.windAt(huntingDay.startTime.time).speed)))mph",
            "\(Int(round(dailyWeather.windAt(huntingDay.sunriseTime.time).speed)))mph",
            "\(Int(round(dailyWeather.windAt(huntingDay.sunsetTime.time).speed)))mph",
            "\(Int(round(dailyWeather.windAt(huntingDay.endTime.time).speed)))mph"]
        
        rightColumnView.setLabels(winds)
    }
}
