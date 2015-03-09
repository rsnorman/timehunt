//
//  HuntingTimeParser.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 11/22/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import UIKit

protocol HuntingSeasonDelegate {
    func willChangeDay(currentDay: HuntingDay)
    func didChangeDay(currentDay: HuntingDay)
    func didFailChangeDay()
}

class HuntingSeason {
    let dates             : [HuntingDay]
    let startDate         : NSDate
    let endDate           : NSDate
    var currentPosition   : Int!
    var delegate          : HuntingSeasonDelegate!
    var location          : CLLocation!
    
    init(startDate: NSDate, endDate: NSDate) {
        self.startDate = startDate
        self.endDate   = endDate
        dates = []
        
        var date = self.startDate
        for index in 0...(differenceInDays(startDate, endDate) - 1) {
            dates.append(HuntingDay(date: date))
            date = addDay(date)
        }
        
        self.currentPosition = getCurrentPosition()
    }
    
    convenience init(startDate: NSDate, endDate: NSDate, location: CLLocation) {
        self.init(startDate: startDate, endDate: endDate)
        self.location = location
    }
    
    func allDays() -> [HuntingDay?] {
        return dates
    }
    
    func length() -> Int {
        return dates.count
    }
    
    func fetchDay(completion: (error: NSError?, huntingDay: HuntingDay) -> ()) {
        let currentHuntingDay = self.currentDay()
        self.delegate?.willChangeDay(currentHuntingDay)
        WeatherParser.sharedInstance.fetch(location, date: currentHuntingDay.date, success: { (dailyWeather) -> () in
            currentHuntingDay.weather = dailyWeather
            currentHuntingDay.setSunriseSunset(dailyWeather.sunrise!, sunsetTime: dailyWeather.sunset!)
            completion(error: nil, huntingDay: currentHuntingDay)
            self.delegate?.didChangeDay(currentHuntingDay)
        }) { () -> () in
            self.delegate?.didFailChangeDay()
            completion(error: NSError(), huntingDay: currentHuntingDay)
        }
    }
    
    func currentDay() -> HuntingDay {
        return dates[currentPosition]
    }
    
    func nextDay() -> HuntingDay {
        currentPosition = currentPosition + 1
        return currentDay()
    }
    
    func previousDay() -> HuntingDay {
        currentPosition = currentPosition - 1
        return currentDay()
    }
    
    func openingDay() -> Bool {
        return currentPosition == 0
    }
    
    func closingDay() -> Bool {
        return currentPosition == dates.count - 1
    }
    
    func setCurrentDay(currentDay: Int) {
        delegate?.willChangeDay(self.currentDay())
        currentPosition = currentDay
        delegate?.didChangeDay(self.currentDay())
    }
    
    func percentComplete() -> CGFloat {
        return CGFloat(currentPosition) / CGFloat(dates.count)
    }
    
    private
    
    func getCurrentPosition() -> Int {
        
        if dates[0].date.timeIntervalSinceNow > 0 {
            return 0
        } else {
            return differenceInDays(dates[0].date, NSDate())
        }
    }
}
