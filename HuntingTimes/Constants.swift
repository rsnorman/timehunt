//
//  Constants.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 11/28/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import UIKit

let MAX_NOTIFICATIONS: Int = 3
let SECOND_NOTIFICATION_INTERVAL: NSTimeInterval = 60 * 15
let THIRD_NOTIFICATION_INTERVAL: NSTimeInterval = 60 * 60

let DAY_TRANSITION_TIME: NSTimeInterval = 0.5

let HUNTING_SEASON_START_DATE: NSDate = {
    let currentCalendar = NSCalendar.currentCalendar()
    let dateComponents  = currentCalendar.components(.YearCalendarUnit, fromDate: NSDate())
    dateComponents.month = 11
    dateComponents.day = 20
    return currentCalendar.dateFromComponents(dateComponents)!
}()

let HUNTING_SEASON_END_DATE: NSDate = {
    let currentCalendar = NSCalendar.currentCalendar()
    let dateComponents  = currentCalendar.components(.YearCalendarUnit, fromDate: NSDate())
    dateComponents.month = 12
    dateComponents.day = 31
    return currentCalendar.dateFromComponents(dateComponents)!
}()