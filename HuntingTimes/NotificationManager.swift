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
    let huntingTime  : (time: NSDate, event: String)
    
    init(huntingTime: (time: NSDate, event: String), scheduleTime: NSDate) {
        self.huntingTime       = huntingTime
        let localNotif         = UILocalNotification()
        localNotif.fireDate    = scheduleTime
        localNotif.alertBody   = "\(huntingTime.event) is starting"
        localNotif.alertAction = "View Details"
        localNotif.userInfo    = [ "key" : Notification.key(huntingTime), "time" : huntingTime.time, "event" : huntingTime.event ]
        
        println("Schedule notification: \(Notification.key(huntingTime))")
        UIApplication.sharedApplication().scheduleLocalNotification(localNotif)
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
            var scheduleTime = huntingTime.time
            if count == 1 {
                scheduleTime = scheduleTime.dateByAddingTimeInterval(60 * 15)
            } else if count == 2 {
                scheduleTime = scheduleTime.dateByAddingTimeInterval(60 * 60)
            }
            
            let huntingNotification = Notification(huntingTime: huntingTime, scheduleTime: scheduleTime)
            for del in delegates {
                del.didAddNotification(huntingNotification)
            }
        }
    }
    
    func removeAllNotifications(huntingTime: (time: NSDate, event: String)) {
        println("Remove all notifications")
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
        return getAllNotifications(huntingTime).count < 3
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


