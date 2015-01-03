//
//  TimesViewController.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 1/3/15.
//  Copyright (c) 2015 Ryan Norman. All rights reserved.
//

import Foundation
import AudioToolbox

class TimesViewController : UIViewController, CountdownViewDelegate, HuntingTimesViewDelegate, NotificationManagerDelegate, MessageViewDelegate {
    var timesView: TimesView!
    var huntingDay : HuntingDay
    var huntingTimesProgress : HuntingTimeProgress!
    var huntingTimesView : HuntingTimesView!
    
    init(huntingDay: HuntingDay) {
        self.huntingDay = huntingDay
        super.init(nibName: nil, bundle: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "setCountdownTime", name: UIApplicationDidBecomeActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "setNotifications", name: UIApplicationDidBecomeActiveNotification, object: nil)
        
        NotificationManager.sharedInstance.addDelegate(self)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDay(huntingDay: HuntingDay) {
        self.huntingDay = huntingDay
        timesView.huntingColumnsView.setDay(huntingDay)
        timesView.dateLabel.text = currentTime().toDateString()
        huntingTimesProgress.huntingDay = huntingDay
        
        setCountdownTime()
        setNotifications()
    }
    
    override func viewDidLoad() {
        timesView = TimesView(frame: self.view.frame)
        timesView.messageLabel.delegate = self
        timesView.countdownLabel.delegate = self

        
        huntingTimesView = timesView.huntingColumnsView as HuntingTimesView
        huntingTimesView.delegate = self
        
        huntingTimesProgress = HuntingTimeProgress(huntingTimesColumn: huntingTimesView.timeColumnView)
        
        setDay(huntingDay)
        
        self.view = timesView
        self.view.alpha = 0
        
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.view.alpha = 1
        }, nil)
    }
    
    func willShowMessage() {
        timesView.countdownLabel.alpha = 0.0
    }
    
    func didHideMessage() {
        timesView.countdownLabel.alpha = 1.0
    }
    
    func didAddNotification(notificationable: NotificationInterface, notification: Notification) {
        timesView.messageLabel.addMessage(notification.getMessage())
        huntingTimesView.addNotificationIcon(notificationable.userInfo()["time"] as NSDate)
    }
    
    func didRemoveAllNotifications(notificationable: NotificationInterface) {
        let event = notificationable.userInfo()["event"] as String
        let time  = notificationable.userInfo()["time"] as NSDate
        timesView.messageLabel.addMessage("Removed All \(event) Notifications")
        huntingTimesView.removeNotificationIcons(time)
    }
    
    func didReceiveNotification(userInfo: [NSObject : AnyObject]) {
        let event = userInfo["event"] as String
        let time  = userInfo["time"] as NSDate
        
        huntingTimesView.removeNotificationIcon(time, event: event)
        
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
    func setCountdownTime() {
        timesView.countdownLabel.stopCountdown()
        if !huntingDay.isEnded() {
            timesView.countdownLabel.startCountdown(currentTime().time)
            timesView.stateLabel.text = currentTime().event
        } else {
            timesView.stateLabel.text = ""
//            mainView.dateTimeScroller.setPosition(huntingTimesProgress.getProgressPercent(), animate: true)
        }
    }
    
    func didTickCountdown() {
//        mainView.dateTimeScroller.setPosition(huntingTimesProgress.getProgressPercent(), animate: true)
    }
    
    func willFinishCountdown() {
        UIView.animateWithDuration(0.5, delay: 0.9, options: nil, animations: { () -> Void in
            self.timesView.countdownLabel.alpha = 0.0
            }, completion: nil)
    }
    
    func didFinishCountdown() {
        setCountdownTime()
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.timesView.countdownLabel.alpha = 1.0
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
    
    func currentTime() -> HuntingTime {
        return huntingDay.getCurrentTime()
    }
    
    func startChangingDay(reverse: Bool = false, completion: ((reversing: Bool) -> Void)? = nil) {
        let labelOffset : CGFloat = 10.0
        let yOffset = reverse ? labelOffset * -1 : labelOffset
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.timesView.alpha = 0
            self.huntingTimesView.frame = CGRectOffset(self.huntingTimesView.frame, 0, yOffset)
        }) { (complete) -> Void in
            
            self.huntingTimesView.frame = CGRectOffset(self.huntingTimesView.frame, 0, yOffset * -2)
            if let completionHandler = completion {
                completionHandler(reversing: reverse)
            }
        }
    }
    
    func finishChangingDay(reverse: Bool = false, completion: ((reversing: Bool) -> Void)? = nil) {
        let labelOffset: CGFloat = 10.0
        let yOffset = reverse ? labelOffset * -1 : labelOffset
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.timesView.alpha = 1
            self.huntingTimesView.frame = CGRectOffset(self.huntingTimesView.frame, 0, yOffset)
            }) { (complete) -> Void in
                
                if let completionHandler = completion {
                    completionHandler(reversing: reverse)
                }
        }
    }
}