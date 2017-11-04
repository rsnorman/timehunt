//
//  NotificationManager.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 11/26/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import UIKit

protocol NotificationManagerDelegate {
    func didAddNotification(_ notificationable: NotificationInterface, notification: Notification)
    func didRemoveAllNotifications(_ notificationable: NotificationInterface)
    func didReceiveNotification(_ userInfo: [AnyHashable: Any])
}

protocol NotificationInterface {
    func key() -> String
    func alert(_ additionalAlertInterval: String) -> String
    func message(_ additionalAlertInterval: String) -> String
    func scheduleTime() -> Date
    func userInfo() -> [AnyHashable: Any]
}

class Notification {
    let notificationable   : NotificationInterface
    let additionalInterval : TimeInterval
    
    init(notificationable: NotificationInterface, additionalInterval: TimeInterval) {
        self.notificationable              = notificationable
        self.additionalInterval            = additionalInterval
        
        if canSchedule() {
            let localNotification              = UILocalNotification()
            localNotification.fireDate         = notificationable.scheduleTime().addingTimeInterval(additionalInterval * -1)
            localNotification.alertBody        = notificationable.alert(getTime())
            localNotification.alertAction      = "View Details"
            localNotification.soundName        = "silence.mp3"
            localNotification.userInfo         = notificationable.userInfo()
            localNotification.userInfo!["key"] = notificationable.key()

            UIApplication.shared.scheduleLocalNotification(localNotification)
        }
    }
    
    func canSchedule() -> Bool {
        return notificationable.scheduleTime().addingTimeInterval(additionalInterval * -1).timeIntervalSinceNow > 0
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
    
    func addDelegate(_ delegate: NotificationManagerDelegate) {
        delegates.append(delegate)
    }
    
    func addNotification(_ notificationable: NotificationInterface) {
        if canAddNotifications(notificationable) {
            let notification = Notification(notificationable: notificationable, additionalInterval: getInterval(notificationable.key()))
            
            for del in delegates {
                del.didAddNotification(notificationable, notification: notification)
            }
        }
    }
    
    func removeAllNotifications(_ notificationable: NotificationInterface) {
        for notification in getAllNotificationsForKey(notificationable.key()) {
            UIApplication.shared.cancelLocalNotification(notification)
        }
        
        for del in delegates {
            del.didRemoveAllNotifications(notificationable)
        }
    }
    
    func getAllNotificationsForKey(_ key: String) -> [UILocalNotification] {
        var notifications: [UILocalNotification] = []
        
        for notification in UIApplication.shared.scheduledLocalNotifications! as [UILocalNotification] {
            if notification.userInfo?["key"] as! String == key {
                notifications.append(notification)
            }
        }
        
        return notifications as [UILocalNotification]
    }
    
    func canAddNotifications(_ notificationable: NotificationInterface) -> Bool {
        return getAllNotificationsForKey(notificationable.key()).count < MAX_NOTIFICATIONS && canSchedule(notificationable)
    }
    
    func receivedNotification(_ notification: UILocalNotification) {
        for del in delegates {
            del.didReceiveNotification(notification.userInfo!)
        }
    }

    fileprivate

    func getInterval(_ key: String) -> TimeInterval {
        let count = getAllNotificationsForKey(key).count
        var additionalInterval : TimeInterval = 0
        if count == 1 {
            additionalInterval = SECOND_NOTIFICATION_INTERVAL
        } else if count == 2 {
            additionalInterval = THIRD_NOTIFICATION_INTERVAL
        }

        return additionalInterval
    }

    func canSchedule(_ notificationable: NotificationInterface) -> Bool {
        return notificationable.scheduleTime().addingTimeInterval(getInterval(notificationable.key()) * -1).timeIntervalSinceNow > 0
    }

    init() {
        delegates = []
//        let notificationTypes = UIUserNotificationType.Alert | UIUserNotificationType.Sound
//        let settings = UIUserNotificationSettings(forTypes: notificationTypes, categories: nil)
//        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
    }
}


