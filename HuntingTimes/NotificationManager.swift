//
//  NotificationManager.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 11/26/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import UIKit

protocol NotificationManagerDelegate {
    func didAddNotification(notificationable: NotificationInterface, notification: Notification)
    func didRemoveAllNotifications(notificationable: NotificationInterface)
}

protocol NotificationInterface {
    func key() -> String
    func alert(additionalAlertInterval: String) -> String
    func message(additionalAlertInterval: String) -> String
    func scheduleTime() -> NSDate
    func userInfo() -> [NSObject : AnyObject]
}

class Notification {
    let notificationable   : NotificationInterface
    let additionalInterval : NSTimeInterval
    
    init(notificationable: NotificationInterface, additionalInterval: NSTimeInterval) {
        self.notificationable              = notificationable
        self.additionalInterval            = additionalInterval
        
        if canSchedule() {
            let localNotification              = UILocalNotification()
            localNotification.fireDate         = notificationable.scheduleTime().dateByAddingTimeInterval(additionalInterval * -1)
            localNotification.alertBody        = notificationable.alert(getTime())
            localNotification.alertAction      = "View Details"
            localNotification.soundName        = "silence.mp3"
            localNotification.userInfo         = notificationable.userInfo()
            localNotification.userInfo!["key"] = notificationable.key()

            UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        }
    }
    
    func canSchedule() -> Bool {
        return notificationable.scheduleTime().dateByAddingTimeInterval(additionalInterval * -1).timeIntervalSinceNow > 0
    }
    
    func getTime() -> String {
        if additionalInterval == 60 * 60 {
            return "1 Hour"
        } else {
            return "\(Int(additionalInterval / 60)) Minutes"
        }
    }
    
    func getMessage() -> String {
        return notificationable.message(getTime())
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
    
    func addNotification(notificationable: NotificationInterface) {
        if canAddNotificationsForKey(notificationable.key()) {
            let count = getAllNotificationsForKey(notificationable.key()).count
            var additionalInterval : NSTimeInterval = 0
            if count == 1 {
                additionalInterval = SECOND_NOTIFICATION_INTERVAL
            } else if count == 2 {
                additionalInterval = THIRD_NOTIFICATION_INTERVAL
            }
            
            let notification = Notification(notificationable: notificationable, additionalInterval: additionalInterval)
            
            if notification.canSchedule() {
                for del in delegates {
                    del.didAddNotification(notificationable, notification: notification)
                }
            }
        }
    }
    
    func removeAllNotifications(notificationable: NotificationInterface) {
        for notification in getAllNotificationsForKey(notificationable.key()) {
            UIApplication.sharedApplication().cancelLocalNotification(notification)
        }
        
        for del in delegates {
            del.didRemoveAllNotifications(notificationable)
        }
    }
    
    func getAllNotificationsForKey(key: String) -> [UILocalNotification] {
        var notifications: [UILocalNotification] = []
        
        for notification in UIApplication.sharedApplication().scheduledLocalNotifications as [UILocalNotification] {
            if notification.userInfo?["key"] as String == key {
                notifications.append(notification)
            }
        }
        
        return notifications as [UILocalNotification]
    }
    
    func canAddNotificationsForKey(key: String) -> Bool {
        return getAllNotificationsForKey(key).count < MAX_NOTIFICATIONS
    }
    
    private
    
    init() {
        delegates = []
        let notificationTypes = UIUserNotificationType.Alert | UIUserNotificationType.Sound
        let settings = UIUserNotificationSettings(forTypes: notificationTypes, categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
    }
}


