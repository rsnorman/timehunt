//
//  WeatherView.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 1/3/15.
//  Copyright (c) 2015 Ryan Norman. All rights reserved.
//

import Foundation

class WeatherView : UIView {
    let huntingWeatherView : HuntingWeatherView
    
    override init(frame: CGRect) {
        huntingWeatherView = HuntingWeatherView(frame: CGRectMake(0, 230, frame.width, frame.height - 285))
        huntingWeatherView.alpha = 1
        
        super.init(frame: frame)
        
        addSubview(huntingWeatherView)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
