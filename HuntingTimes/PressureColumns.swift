//
//  PressureColumns.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 11/4/17.
//  Copyright © 2017 Ryan Norman. All rights reserved.
//

import Foundation
import UIKit

class PressureColumns : HuntingColumnsView {
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func setDay(_ huntingDay: HuntingDay) {
        super.setDay(huntingDay)
        
        leftColumnView.setLabels([huntingDay.startTime.toTimeString(), huntingDay.sunriseTime.toTimeString(), huntingDay.sunsetTime.toTimeString(), huntingDay.endTime.toTimeString()])
        
        setPressures(huntingDay.weather)
    }
    
    
    func setPressures(_ dailyWeather: DailyWeather) {
        let pressures = [pressureToString(dailyWeather.pressureAt(huntingDay.startTime.time)),
                     pressureToString(dailyWeather.pressureAt(huntingDay.sunriseTime.time)),
                     pressureToString(dailyWeather.pressureAt(huntingDay.sunsetTime.time)),
                     pressureToString(dailyWeather.pressureAt(huntingDay.endTime.time))]
        
        rightColumnView.setLabels(pressures)
    }
}
