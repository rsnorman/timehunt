//
//  HuntingWeatherView.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 12/11/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import UIKit

class HuntingWeatherView : UIView, FCLocationManagerDelegate {
    let weatherColumnView : ColumnView
    let timeColumnView    : ColumnView
    let padding           : CGFloat = 15
    var huntingDay        : HuntingDay!
    
    let locationManager   : FCLocationManager
    let forecastr         : Forecastr
    
    override init(frame: CGRect) {
        timeColumnView = ColumnView(labels: [], frame: CGRectMake(0, 0, frame.width / 2.0 - padding, frame.height))
        timeColumnView.setTextAlignment(NSTextAlignment.Right)
        
        weatherColumnView = ColumnView(labels: ["45°", "46°", "48°", "46°"], frame: CGRectMake(frame.width / 2.0 + padding, 0, frame.width / 2.0 - padding, frame.height))
        weatherColumnView.setTextAlignment(NSTextAlignment.Left)
        
        locationManager = FCLocationManager.sharedManager() as FCLocationManager
        forecastr = Forecastr.sharedManager() as Forecastr
        forecastr.apiKey = "8ab15e9dc5a398ed2698ea831d1efb82"
        
        super.init(frame: frame)
        
        locationManager.delegate = self
        
        addSubview(weatherColumnView)
        addSubview(timeColumnView)
    }
    
    func setDay(huntingDay: HuntingDay) {
        self.huntingDay = huntingDay
        timeColumnView.setLabels([huntingDay.startTime.toTimeString(), huntingDay.sunriseTime.toTimeString(), huntingDay.sunsetTime.toTimeString(), huntingDay.endTime.toTimeString()])
        
        locationManager.startUpdatingLocation()
    }
    
    // Basic forecast example
    func exampleForecastForLocation(location: CLLocation) {
        forecastr.getForecastForLocation(location, time: nil, exclusions: nil, extend: nil, language: nil, success: {(json) -> Void in
            let weatherData = json as Dictionary<String, AnyObject>
    
            if let hourly = weatherData["hourly"] as? [String : AnyObject] {
                if let hourlyData = hourly["data"] as? [AnyObject] {
                    for hourData in hourlyData {
                        println(hourData)
                    }
                }
            }
        }, failure: nil)
    }
    
    func didAcquireLocation(location: CLLocation!) {
        exampleForecastForLocation(location)
        locationManager.findNameForLocation(location)
    }
    
    func didFailToAcquireLocationWithErrorMsg(errorMsg: String!) {
        println(errorMsg)
    }

    func didFindLocationName(locationName: String!) {
        println("Found location: \(locationName)")
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
