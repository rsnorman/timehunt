//
//  WeatherView.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 1/3/15.
//  Copyright (c) 2015 Ryan Norman. All rights reserved.
//

import Foundation

class TemperaturePage : HuntingPageView {
    required init(frame: CGRect) {
        super.init(frame: frame, huntingColumnsClass: TemperatureColumns.self)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
