//
//  NotificationManager.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 11/26/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import UIKit

protocol NotificationManagerDelegate {
    func didAddNotification(notification: Notification)
    func didRemoveAllNotifications(huntingTime: (time: NSDate, event: String))
}

class Notification {
    let huntingTime        : (time: NSDate, event: String)
    let additionalInterval : NSTimeInterval
    
    init(huntingTime: (time: NSDate, event: String), additionalInterval: NSTimeInterval) {
        self.huntingTime        = huntingTime
        self.additionalInterval = additionalInterval
        
        let localNotif          = UILocalNotification()
        localNotif.fireDate     = huntingTime.time.dateByAddingTimeInterval(additionalInterval)
        localNotif.alertBody    = createAlert()
        localNotif.alertAction  = "View Details"
        localNotif.userInfo     = [ "key" : Notification.key(huntingTime), "time" : huntingTime.time, "event" : huntingTime.event ]

        UIApplication.sharedApplication().scheduleLocalNotification(localNotif)
    }
    
    func createAlert() -> String {
        if additionalInterval == 0 {
            switch huntingTime.event {
            case "Start":
                return "Start hunting!"
            case "Sunrise":
                return "The sun has risen"
            case "Sunset":
                return "The sun has set"
            default:
                return "Hunting is over for the day"
            }
        } else {
            switch huntingTime.event {
            case "Start":
                return "Hunting starts in \(getTime().lowercaseString)"
            case "Sunrise":
                return "The sun rises in \(getTime().lowercaseString)"
            case "Sunset":
                return "The sun sets in \(getTime().lowercaseString)"
            default:
                return "Hunting ends in \(getTime().lowercaseString)"
            }
        }
    }
    
    func getTime() -> String {
        if additionalInterval == 60 * 60 {
            return "1 Hour"
        } else {
            return "\(Int(additionalInterval / 60)) Minutes"
        }
    }
    
    func getMessage() -> String {
        if additionalInterval == 0 {
            return "Added \(huntingTime.event) Notification"
        } else {
            return "Added \(getTime()) Until \(huntingTime.event) Notification"
        }
    }
    
    class func key(huntingTime: (time: NSDate, event: String)) -> String {
        return "\(huntingTime.event):\(dateToString(clearTime(huntingTime.time), useRelativeString: false))"
    }
}

class NotificationManager {
    var delegates : [NotificationManagerDelegate]
    
    class var sharedInstance : NotificationManager {
        struct Static {
            static let instance : NotificationManager = NotificationManager()
        }
        return Static.instance
    }
    
    func addDelegate(delegate: NotificationManagerDelegate) {
        delegates.append(delegate)
    }
    
    func addNotification(huntingTime: (time: NSDate, event: String)) {
        if canAddNotifications(huntingTime) {
            let count = getAllNotifications(huntingTime).count
            var additionalInterval : NSTimeInterval = 0
            if count == 1 {
                additionalInterval = 60 * 15
            } else if count == 2 {
                additionalInterval = 60 * 60
            }
            
            let huntingNotification = Notification(huntingTime: huntingTime, additionalInterval: additionalInterval)
            for del in delegates {
                del.didAddNotification(huntingNotification)
            }
        }
    }
    
    func removeAllNotifications(huntingTime: (time: NSDate, event: String)) {
        if huntingTime.time.timeIntervalSinceNow < 0 {
            return
        }
        
        for notification in getAllNotifications(huntingTime) {
            UIApplication.sharedApplication().cancelLocalNotification(notification)
        }
        
        for del in delegates {
            del.didRemoveAllNotifications(huntingTime)
        }
    }
    
    func getAllNotifications(huntingTime: (time: NSDate, event: String)) -> [UILocalNotification] {
        var notifications: [UILocalNotification] = []
        
        for notification in UIApplication.sharedApplication().scheduledLocalNotifications as [UILocalNotification] {
            if notification.userInfo!["key"] as String == notificationKey(huntingTime) {
               notifications.append(notification)
            }
        }
        
        return notifications as [UILocalNotification]
    }
    
    func canAddNotifications(huntingTime: (time: NSDate, event: String)) -> Bool {
        return huntingTime.time.timeIntervalSinceNow > 0 && getAllNotifications(huntingTime).count < 3
    }
    
    private
    
    init() {
        delegates = []
        let notificationTypes = UIUserNotificationType.Alert
        let settings = UIUserNotificationSettings(forTypes: notificationTypes, categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
    }
    
    func notificationKey(huntingTime: (time: NSDate, event: String)) -> String {
        return Notification.key(huntingTime)
    }
}


