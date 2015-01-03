//
//  WeatherViewController.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 1/3/15.
//  Copyright (c) 2015 Ryan Norman. All rights reserved.
//

import Foundation

class WeatherViewController : UIViewController {
    var weatherView: WeatherView!
    let huntingDay : HuntingDay
    
    init(huntingDay: HuntingDay) {
        self.huntingDay = huntingDay
        super.init(nibName: nil, bundle: nil)
    
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        weatherView = WeatherView(frame: self.view.frame)
        weatherView.huntingWeatherView.setDay(huntingDay)
        
        self.view = weatherView
        
        super.viewDidLoad()
    }
}
