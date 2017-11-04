//
//  WindPageController.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 11/4/17.
//  Copyright © 2017 Ryan Norman. All rights reserved.
//

import Foundation

class WindPageController : HuntingPageController {
    init(huntingDay: HuntingDay) {
        super.init(huntingDay: huntingDay, huntingPageClass: WindPage.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        huntingPageView?.stateLabel.text = "Wind"
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didSetDay(_ huntingDay: HuntingDay) {
        super.didSetDay(huntingDay)
        
        if huntingDay.weather.hasCurrent() {
            huntingPageView?.stateLabel.text = "Current Wind"
            huntingPageView?.mainLabel.text = "\(huntingDay.weather.currentWind().speed)mph"
        } else {
            huntingPageView?.stateLabel.text = "Average Wind"
            huntingPageView?.mainLabel.text = "\(huntingDay.weather.currentWind().speed)mph"
        }
    }
}
