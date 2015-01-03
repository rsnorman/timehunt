//
//  TimesViewController.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 1/3/15.
//  Copyright (c) 2015 Ryan Norman. All rights reserved.
//

import Foundation
import AudioToolbox

class TimesViewController : HuntingPageController, CountdownViewDelegate, HuntingTimesViewDelegate, NotificationManagerDelegate, MessageViewDelegate {
    var huntingTimesProgress : HuntingTimeProgress!
    var huntingTimesView : HuntingTimesView!
    
    init(huntingDay: HuntingDay) {
        super.init(huntingDay: huntingDay, huntingPageClass: TimesView.self)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "setCountdownTime", name: UIApplicationDidBecomeActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "setNotifications", name: UIApplicationDidBecomeActiveNotification, object: nil)
        
        NotificationManager.sharedInstance.addDelegate(self)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didSetDay(huntingDay: HuntingDay) {
        super.didSetDay(huntingDay)
        
        huntingPageView.dateLabel.text  = currentTime().toDateString()
        huntingTimesProgress.huntingDay = huntingDay
        
        setCountdownTime()
        setNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        huntingPageView.messageLabel.delegate = self
        (huntingPageView as TimesView).countdownLabel.delegate = self

        huntingTimesView = huntingPageView.huntingColumnsView as HuntingTimesView
        huntingTimesView.delegate = self
        
        huntingTimesProgress = HuntingTimeProgress(huntingTimesColumn: huntingTimesView.timeColumnView)
        
        self.view.alpha = 0
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.view.alpha = 1
        }, nil)
    }
    
    func willShowMessage() {
        (huntingPageView as TimesView).countdownLabel.alpha = 0.0
    }
    
    func didHideMessage() {
        (huntingPageView as TimesView).countdownLabel.alpha = 1.0
    }
    
    func didAddNotification(notificationable: NotificationInterface, notification: Notification) {
        huntingPageView.messageLabel.addMessage(notification.getMessage())
        huntingTimesView.addNotificationIcon(notificationable.userInfo()["time"] as NSDate)
    }
    
    func didRemoveAllNotifications(notificationable: NotificationInterface) {
        let event = notificationable.userInfo()["event"] as String
        let time  = notificationable.userInfo()["time"] as NSDate
        huntingPageView.messageLabel.addMessage("Removed All \(event) Notifications")
        huntingTimesView.removeNotificationIcons(time)
    }
    
    func didReceiveNotification(userInfo: [NSObject : AnyObject]) {
        let event = userInfo["event"] as String
        let time  = userInfo["time"] as NSDate
        
        huntingTimesView.removeNotificationIcon(time, event: event)
        
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
    func setCountdownTime() {
        (huntingPageView as TimesView).countdownLabel.stopCountdown()
        if !huntingDay.isEnded() {
            (huntingPageView as TimesView).countdownLabel.startCountdown(currentTime().time)
            huntingPageView.stateLabel.text = currentTime().event
        } else {
            huntingPageView.stateLabel.text = ""
//            mainView.dateTimeScroller.setPosition(huntingTimesProgress.getProgressPercent(), animate: true)
        }
    }
    
    func didTickCountdown() {
//        mainView.dateTimeScroller.setPosition(huntingTimesProgress.getProgressPercent(), animate: true)
    }
    
    func willFinishCountdown() {
        UIView.animateWithDuration(0.5, delay: 0.9, options: nil, animations: { () -> Void in
            (self.huntingPageView as TimesView).countdownLabel.alpha = 0.0
            }, completion: nil)
    }
    
    func didFinishCountdown() {
        setCountdownTime()
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            (self.huntingPageView as TimesView).countdownLabel.alpha = 1.0
        })
    }
    
    func didTapHuntingTime(huntingTime: HuntingTime) {
        let notificationManager = NotificationManager.sharedInstance
        if notificationManager.canAddNotificationsForKey(huntingTime.key()) {
            notificationManager.addNotification(huntingTime)
        } else {
            notificationManager.removeAllNotifications(huntingTime)
        }
    }
    
    func setNotifications() {
        huntingTimesView.removeAllNotifications()
        for (index, time) in enumerate(huntingDay.allTimes()) {
            let notifications = NotificationManager.sharedInstance.getAllNotificationsForKey(time.key())
            for notification in notifications {
                huntingTimesView.addNotificationIcon(time.time, animate: false)
            }
        }
    }
}