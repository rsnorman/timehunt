//
//  Constants.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 11/28/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import UIKit

let MAX_NOTIFICATIONS: Int = 3
let SECOND_NOTIFICATION_INTERVAL: TimeInterval = 60 * 15
let THIRD_NOTIFICATION_INTERVAL: TimeInterval = 60 * 60

let DAY_TRANSITION_TIME: TimeInterval = 0.5

let HUNTING_SEASON_START_DATE: Date = {
    let currentCalendar = Calendar.current
    let unitFlags = Set<Calendar.Component>([.year])
    var dateComponents  = currentCalendar.dateComponents(unitFlags, from: Date())
    dateComponents.month = 11
    dateComponents.day = 20
    return currentCalendar.date(from: dateComponents)!
}()

let HUNTING_SEASON_END_DATE: Date = {
    let currentCalendar = Calendar.current
    let unitFlags = Set<Calendar.Component>([.year])
    var dateComponents  = currentCalendar.dateComponents(unitFlags, from: Date())
    dateComponents.month = 12
    dateComponents.day = 31
    return currentCalendar.date(from: dateComponents)!
}()
