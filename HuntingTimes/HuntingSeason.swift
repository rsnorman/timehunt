//
//  HuntingTimeParser.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 11/22/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import UIKit
import CoreLocation

protocol HuntingSeasonDelegate {
    func willChangeDay(_ currentDay: HuntingDay)
    func didChangeDay(_ currentDay: HuntingDay)
    func didFailChangeDay()
}

class HuntingSeason {
    let dates             : [HuntingDay]
    let startDate         : Date
    let endDate           : Date
    var currentPosition   : Int!
    var delegate          : HuntingSeasonDelegate!
    var location          : CLLocation!
    
    init(startDate: Date, endDate: Date) {
        self.startDate = startDate
        self.endDate   = endDate
        var seasonDates: [HuntingDay] = []
        
        var date = self.startDate
        for _ in 0...(differenceInDays(startDate, otherDate: endDate) - 1) {
            seasonDates.append(HuntingDay(date: date))
            date = addDay(date)
        }
        
        dates = seasonDates
        self.currentPosition = getCurrentPosition()
    }
    
    convenience init(startDate: Date, endDate: Date, location: CLLocation) {
        self.init(startDate: startDate, endDate: endDate)
        self.location = location
    }
    
    func allDays() -> [HuntingDay?] {
        return dates
    }
    
    func length() -> Int {
        return dates.count
    }
    
    func fetchDay(_ completion: @escaping (_ error: NSError?, _ huntingDay: HuntingDay) -> ()) {
        let currentHuntingDay = self.currentDay()
        self.delegate?.willChangeDay(currentHuntingDay)
        WeatherParser.sharedInstance.fetch(location, date: currentHuntingDay.date, success: { (dailyWeather) -> () in
            currentHuntingDay.weather = dailyWeather
            currentHuntingDay.setSunriseSunset(dailyWeather.sunrise!, sunsetTime: dailyWeather.sunset!)
            completion(nil, currentHuntingDay)
            self.delegate?.didChangeDay(currentHuntingDay)
        }) { () -> () in
            self.delegate?.didFailChangeDay()
            completion(NSError(), currentHuntingDay)
        }
    }
    
    func currentDay() -> HuntingDay {
        return dates[currentPosition]
    }
    
    func moveToNextDay() {
        currentPosition = currentPosition + 1
    }
    
    func moveToPreviousDay() {
        currentPosition = currentPosition - 1
    }
    
    func openingDay() -> Bool {
        return currentPosition == 0
    }
    
    func closingDay() -> Bool {
        return currentPosition == dates.count - 1
    }
    
    func setCurrentDay(_ currentDay: Int) {
        delegate?.willChangeDay(self.currentDay())
        currentPosition = currentDay
        delegate?.didChangeDay(self.currentDay())
    }
    
    func percentComplete() -> CGFloat {
        return CGFloat(currentPosition) / CGFloat(dates.count)
    }
    
    fileprivate
    
    func getCurrentPosition() -> Int {
        
        if dates[0].date.timeIntervalSinceNow > 0 {
            return 0
        } else {
            return differenceInDays(dates[0].date, otherDate: Date())
        }
    }
}
