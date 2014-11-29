//
//  ViewController.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 11/21/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import UIKit
import AudioToolbox

class ViewController: UIViewController, CountdownViewDelegate, ScrollLineViewDelegate, HuntingTimesViewDelegate, NotificationManagerDelegate, MessageViewDelegate {
    
    var mainView : MainView!
    var animator : MainViewAnimations!
    
    var touchDelay           : dispatch_cancelable_closure!
    var startScrollPosition  : CGPoint!
    var huntingSeason        : HuntingSeason!
    var huntingTimesProgress : HuntingTimeProgress!

    override func viewDidLoad() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "setCountdownTime", name: UIApplicationDidBecomeActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "setNotifications", name: UIApplicationDidBecomeActiveNotification, object: nil)
        
        super.viewDidLoad()
        view.userInteractionEnabled = true
        view.alpha                  = 0
        
        mainView = MainView(frame: view.frame)
        mainView.setDelegate(self)
        view.addSubview(mainView)
        
        huntingSeason = HuntingSeason()
        animator = MainViewAnimations(mainView: mainView)
        addDateGestures()
        NotificationManager.sharedInstance.addDelegate(self)
        huntingTimesProgress = HuntingTimeProgress(huntingDay: currentDay(), huntingTimesColumn: mainView.huntingTimesView.timeColumnView)
        mainView.dateTimeScroller.markCurrentPosition(huntingSeason.percentComplete())
        
        
        setHuntingDay()
    }
    
    override func viewDidAppear(animated: Bool) {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.view.alpha = 1
        })  { (complete) -> Void in
            self.animator.showHuntingTimes()
        }
    }
    
    
    /* Helper Methods */
    
    func currentDay() -> HuntingDay {
        return huntingSeason.currentDay()
    }

    func currentTime() -> HuntingTime {
        return currentDay().getCurrentTime()
    }

    func setHuntingDay() {
        mainView.huntingTimesView.setDay(currentDay())
        huntingTimesProgress.huntingDay = currentDay()
        mainView.dateLabel.text = currentTime().toDateString()
        self.setCountdownTime()
        self.setNotifications()
    }
    
    /* End Helper Methods */
    
    
    
    /* Action Methods */
    
    
    func startScrollDates() {
        if mainView.isDatePickerVisible() {
            animator.hideDailyView() { (complete) -> Void in
                self.animator.showDatePicker(self.huntingSeason.percentComplete())
            }
        }
    }
    
    func stopScrollDates() {
        if !mainView.isDatePickerVisible() {
            animator.hideDatePicker() { (complete) -> Void in
                self.setHuntingDay()
                self.startScrollPosition = nil
                self.animator.showDailyView()
            }
        }
    }
    
    func setCountdownTime() {
        mainView.countdownLabel.stopCountdown()
        if !currentDay().isEnded() {
            mainView.countdownLabel.startCountdown(currentTime().time)
            mainView.stateLabel.text = currentTime().event
        } else {
            mainView.stateLabel.text = ""
            mainView.dateTimeScroller.setPosition(huntingTimesProgress.getProgressPercent(), animate: true)
        }
    }
    
    func showNextDate() {
        if !animator.isAnimating() && !huntingSeason.closingDay() {
            self.mainView.dateTimeScroller.setPosition(1, animate: true)
            animator.hideHuntingTimes(reverse: false) { (reverse, complete) -> Void in
                self.mainView.dateTimeScroller.setPosition(0, animate: false)
                self.huntingSeason.nextDay()
                self.setHuntingDay()
                self.animator.showHuntingTimes(reverse: reverse)
            }
        }
    }
    
    func showPreviousDate() {
        if !animator.isAnimating() && !huntingSeason.openingDay() {
            self.mainView.dateTimeScroller.setPosition(0, animate: true)
            animator.hideHuntingTimes(reverse: true) { (reverse, complete) -> Void in
                self.mainView.dateTimeScroller.setPosition(1, animate: false)
                self.huntingSeason.previousDay()
                self.setHuntingDay()
                self.animator.showHuntingTimes(reverse: reverse)
            }
        }
    }
    
    func setNotifications() {
        mainView.huntingTimesView.removeAllNotifications()
        for (index, time) in enumerate(currentDay().allTimes()) {
            let notifications = NotificationManager.sharedInstance.getAllNotificationsForKey(time.key())
            for notification in notifications {
                mainView.huntingTimesView.addNotificationIcon(time.time, animate: false)
            }
        }
    }
    
    /* End Action Methods */
    
    
    /* Delegate Methods */
    
    func willShowMessage() {
        self.mainView.countdownLabel.alpha = 0.0
    }
    
    func didHideMessage() {
        self.mainView.countdownLabel.alpha = 1.0
    }
    
    func didPositionIndicator(percent: CGFloat) {
        let totalDays  = huntingSeason.length()
        let currentDay = Int(round(CGFloat(totalDays - 1) * percent))
        huntingSeason.setCurrentDay(currentDay)
        mainView.datepickerLabel.text = currentTime().toDateString()
    }
    
    func didTapHuntingTime(huntingTime: HuntingTime) {
        let notificationManager = NotificationManager.sharedInstance
        if notificationManager.canAddNotificationsForKey(huntingTime.key()) {
            notificationManager.addNotification(huntingTime)
        } else {
            notificationManager.removeAllNotifications(huntingTime)
        }
    }
    
    func didAddNotification(notificationable: NotificationInterface, notification: Notification) {
        mainView.messageLabel.addMessage(notification.getMessage())
        mainView.huntingTimesView.addNotificationIcon(notificationable.userInfo()["time"] as NSDate)
    }
    
    func didRemoveAllNotifications(notificationable: NotificationInterface) {
        let event = notificationable.userInfo()["event"] as String
        let time  = notificationable.userInfo()["time"] as NSDate
        mainView.messageLabel.addMessage("Removed All \(event) Notifications")
        mainView.huntingTimesView.removeNotificationIcons(time)
    }
    
    func didReceiveNotification(userInfo: [NSObject : AnyObject]) {
        let event = userInfo["event"] as String
        let time  = userInfo["time"] as NSDate
        
        mainView.huntingTimesView.removeNotificationIcon(time, event: event)
        
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
    func didTickCountdown() {
        mainView.dateTimeScroller.setPosition(huntingTimesProgress.getProgressPercent(), animate: true)
    }
    
    func willFinishCountdown() {
        UIView.animateWithDuration(0.5, delay: 0.9, options: nil, animations: { () -> Void in
            self.mainView.countdownLabel.alpha = 0.0
            }, completion: nil)
    }
    
    func didFinishCountdown() {
        setCountdownTime()
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.mainView.countdownLabel.alpha = 1.0
        })
    }


    /* End Delegate Methods*/
    
    
    
    /* Touch Delegates */
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        touchDelay = delay(0.3) {
            for touch in touches {
                self.startScrollPosition = touch.locationInView(self.view)
            }
            self.touchDelay = nil
            self.startScrollDates()
        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        if touchDelay != nil {
            touchDelay(cancel: true)
        } else {
            stopScrollDates()
        }
    }
    
    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
        if touchDelay != nil {
            touchDelay(cancel: true)
        } else {
            stopScrollDates()
        }
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        if mainView.monthColumnView.hidden == false {
            for touch in touches {
                mainView.dateTimeScroller.setOffsetPosition((touch.locationInView(view).y - startScrollPosition.y))
                startScrollPosition = touch.locationInView(view)
            }
        }
    }
    
    /* End Touch Delegates */

    
    
    /* Gestures */
    
    func addDateGestures() {
        let nextDateGesture       = UISwipeGestureRecognizer(target: self, action: "showPreviousDate")
        nextDateGesture.direction = .Up
        view.addGestureRecognizer(nextDateGesture)
        
        let previousDateGesture       = UISwipeGestureRecognizer(target: self, action: "showNextDate")
        previousDateGesture.direction = .Down
        view.addGestureRecognizer(previousDateGesture)
        
        let swipeRightGesture       = UISwipeGestureRecognizer(target: self, action: "showPreviousDate")
        swipeRightGesture.direction = .Right
        let swipeLeftGesture        = UISwipeGestureRecognizer(target: self, action: "showNextDate")
        swipeLeftGesture.direction  = .Left
        view.addGestureRecognizer(swipeRightGesture)
        view.addGestureRecognizer(swipeLeftGesture)
        
        let hintTapGesture  = UITapGestureRecognizer(target: animator, action: "showSwipeHint")
        view.addGestureRecognizer(hintTapGesture)
    }
    
    /* End Gestures */
}

