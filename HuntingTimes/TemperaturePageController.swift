//
//  WeatherViewController.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 1/3/15.
//  Copyright (c) 2015 Ryan Norman. All rights reserved.
//

import Foundation

class TemperaturePageController : HuntingPageController {
    init(huntingDay: HuntingDay) {
        super.init(huntingDay: huntingDay, huntingPageClass: TemperaturePage.self)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didSetDay(huntingDay: HuntingDay) {
        super.didSetDay(huntingDay)
        
        if huntingDay.weather.hasCurrent() {
            huntingPageView?.stateLabel.text = "Current Temperature"
            huntingPageView?.mainLabel.text = "\(huntingDay.weather.currentTemperature())°"
        } else {
            huntingPageView?.stateLabel.text = "Low/High Temperature"
            huntingPageView?.mainLabel.text = "\(huntingDay.weather.lowTemperature())° / \(huntingDay.weather.highTemperature())°"
        }
    }
}
