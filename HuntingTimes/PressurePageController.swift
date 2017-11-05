//
//  PressurePageController.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 11/4/17.
//  Copyright © 2017 Ryan Norman. All rights reserved.
//

import Foundation

class PressurePageController : HuntingPageController {
    init(huntingDay: HuntingDay) {
        super.init(huntingDay: huntingDay, huntingPageClass: PressurePage.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        huntingPageView?.stateLabel.text = "Pressure"
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didSetDay(_ huntingDay: HuntingDay) {
        super.didSetDay(huntingDay)
        
        if huntingDay.weather.hasCurrent() {
            huntingPageView?.stateLabel.text = "Current Pressure"
            huntingPageView?.mainLabel.text = pressureToString(huntingDay.weather.currentPressure())
        } else {
            huntingPageView?.stateLabel.text = "Average Pressure"
            huntingPageView?.mainLabel.text = pressureToString(huntingDay.weather.predictedPressure())
        }
    }
}

