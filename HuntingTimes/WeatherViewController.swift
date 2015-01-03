//
//  WeatherViewController.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 1/3/15.
//  Copyright (c) 2015 Ryan Norman. All rights reserved.
//

import Foundation

class WeatherViewController : HuntingPageController {
    init(huntingDay: HuntingDay) {
        super.init(huntingDay: huntingDay, huntingPageClass: WeatherView.self)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
