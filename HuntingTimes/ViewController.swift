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
    var reversing            : Bool!
    var animating            : Bool!
    let dateTransitionTime   : Double  = 0.7
    let eventLabelOffset     : CGFloat = 10.0
    var startScrollPosition  : CGPoint!
    
    var bgImageView          : TiltImageView!
    var shadowView           : ShadowView!
    var countdownLabel       : CountdownView!
    var dateLabel            : UILabel!
    var downArrow            : UIImageView!
    var upArrow              : UIImageView!
    var dateTimeScroller     : ScrollLineView!
    var huntingTimesView     : HuntingTimesView!
    var monthColumnView      : ColumnView!
    var monthLabels          : [UILabel]!
    var stateLabel           : UILabel!
    var datepickerLabel      : UILabel!
    var messageLabel         : MessageView!
    
    var touchDelay           : dispatch_cancelable_closure!
    var huntingSeason        : HuntingSeason!
    var huntingTimesProgress : HuntingTimeProgress!
    
    var nextDateGesture      : UISwipeGestureRecognizer!
    var previousDateGesture  : UISwipeGestureRecognizer!
    var swipeRightGesture    : UISwipeGestureRecognizer!
    var swipeLeftGesture     : UISwipeGestureRecognizer!
    var panDatesGesture      : UIPanGestureRecognizer!
    var hintTapGesture       : UITapGestureRecognizer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        StatusBarUpdater.white(animated: false)
        
        reversing = false
        animating = false
        
        huntingSeason = HuntingSeason()
//        huntingSeason.delegate = self
        
        NotificationManager.sharedInstance.addDelegate(self)
        
        addBackground()
        addDateLabels()
        addDateTimeScroller()
        addHuntingTimesView()
        addDatePicker()
        addHints()
        addMessageLabel()
        addDateGestures()
        
        huntingTimesProgress = HuntingTimeProgress(huntingDay: currentDay(), huntingTimesColumn: huntingTimesView.timeColumnView)
        dateTimeScroller.markCurrentPosition(huntingSeason.percentComplete())
        setNotifications()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "hideCountdown", name: UIApplicationWillResignActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showCountdown", name: UIApplicationDidBecomeActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "setNotifications", name: UIApplicationDidBecomeActiveNotification, object: nil)
        
        view.userInteractionEnabled = true
        view.alpha = 0
    }
    
    override func viewDidAppear(animated: Bool) {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.view.alpha = 1
        })  { (complete) -> Void in
            self.addCountdown()
            self.showEventLabels()
        }
    }
    
    
    
    /* Helper Methods */
    
    func currentDay() -> HuntingDay {
        return huntingSeason.currentDay()
    }
    

    func currentTime() -> HuntingTime {
        return currentDay().getTimeFromState(currentState())
    }
    
    func currentState() -> String {
        return currentDay().getCurrentState()
    }
    
    func getHuntingTimes() -> [HuntingTime] {
        return currentDay().allTimes()
    }
    
    func setHuntingDay() {
        huntingTimesView.setDay(currentDay())
        huntingTimesProgress.huntingDay = currentDay()
        dateLabel.text = currentTime().toDateString()
    }
    
    /* End Helper Methods */
    
    
    
    /* Action Methods */
    
    func showCountdown() {
        if let cLabel = self.countdownLabel {
            self.setCountdownTime()
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                cLabel.alpha = 1.0
            })
        }
    }
    
    func hideCountdown() {
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.countdownLabel.alpha = 0.0
        }) { (complete) -> Void in
            self.countdownLabel.stopCountdown()
        }
    }
    
    func startScrollDates() {
        if monthColumnView.hidden == true {
            for gesture in self.view.gestureRecognizers as [UIGestureRecognizer] {
                gesture.enabled = false
            }
            
            monthColumnView.hidden = false
            datepickerLabel.text   = self.dateLabel.text
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.dateTimeScroller.setPosition(self.huntingSeason.percentComplete(), animate: false)
                self.dateTimeScroller.showCurrentPosition()
                self.huntingTimesView.alpha = 0.0
                self.dateLabel.alpha        = 0.0
                self.countdownLabel.alpha   = 0.0
                
                self.downArrow.frame = CGRectOffset(self.downArrow.frame, 0, 5)
                self.downArrow.alpha = 0.7
                
                self.upArrow.frame = CGRectOffset(self.upArrow.frame, 0, -5)
                self.upArrow.alpha = 0.7
            }) { (complete) -> Void in
                self.countdownLabel.stopCountdown()
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.monthColumnView.alpha = 1.0
                    self.datepickerLabel.alpha = 1.0
                })
            }
        }
    }
    
    func stopScrollDates() {
        if monthColumnView.hidden == false {
            for gesture in self.view.gestureRecognizers as [UIGestureRecognizer] {
                gesture.enabled = true
            }
            
            startScrollPosition = nil

            UIView.animateWithDuration(0.3, delay: 0.1, options: nil, animations: { () -> Void in
                self.monthColumnView.alpha = 0.0
                self.datepickerLabel.alpha = 0.0
                self.dateTimeScroller.hideCurrentPosition()
                self.downArrow.frame = CGRectOffset(self.downArrow.frame, 0, 5)
                self.downArrow.alpha = 0.0
                
                self.upArrow.frame = CGRectOffset(self.upArrow.frame, 0, -5)
                self.upArrow.alpha = 0.0
            }) { (complete) -> Void in
                self.downArrow.frame = CGRectOffset(self.downArrow.frame, 0, -10)
                self.upArrow.frame   = CGRectOffset(self.upArrow.frame, 0, 10)
                self.monthColumnView.hidden = true
                self.setHuntingDay()
                self.setCountdownTime()
                self.setNotifications()
                
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.huntingTimesView.alpha = 1.0
                    self.dateLabel.alpha        = 1.0
                    self.countdownLabel.alpha   = 1.0
                })
            }
        }
    }
    
    func showSwipeHint() {
        UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.downArrow.frame = CGRectOffset(self.downArrow.frame, 0, 5)
            self.downArrow.alpha = 0.7
            
            self.upArrow.frame = CGRectOffset(self.upArrow.frame, 0, -5)
            self.upArrow.alpha = 0.7
            }) { (complete) -> Void in
                UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                    self.downArrow.frame = CGRectOffset(self.downArrow.frame, 0, 5)
                    self.downArrow.alpha = 0.0
                    
                    self.upArrow.frame = CGRectOffset(self.upArrow.frame, 0, -5)
                    self.upArrow.alpha = 0.0
                    }, completion: { (complete) -> Void in
                        self.downArrow.frame = CGRectOffset(self.downArrow.frame, 0, -10)
                        self.upArrow.frame   = CGRectOffset(self.upArrow.frame, 0, 10)
                })
        }
    }
    
    func setCountdownTime() {
        countdownLabel.stopCountdown()
        if !currentDay().isEnded() {
            countdownLabel.startCountdown(currentTime().time)
            stateLabel.text = currentTime().event
        } else {
            stateLabel.text = ""
            dateTimeScroller.setPosition(huntingTimesProgress.getProgressPercent(), animate: true)
        }
    }
    
    func showNextDate() {
        if !animating && !huntingSeason.closingDay() {
            animating = true
            reversing = false
            self.dateTimeScroller.setPosition(1, animate: true)
            hideEventLabels(reverse: false) { (complete) -> Void in
                self.animating = false
                self.huntingSeason.nextDay()
                self.setHuntingDay()
                self.dateTimeScroller.setPosition(0, animate: false)
                self.setCountdownTime()
                self.setNotifications()
                self.showEventLabels(reverse: false)
            }
        }
    }
    
    func showPreviousDate() {
        if !animating && !huntingSeason.openingDay() {
            animating = true
            reversing = true
            self.dateTimeScroller.setPosition(0, animate: true)
            hideEventLabels(reverse: true) { (complete) -> Void in
                self.animating = false
                self.huntingSeason.previousDay()
                self.setHuntingDay()
                self.dateTimeScroller.setPosition(1, animate: false)
                self.setCountdownTime()
                self.setNotifications()
                self.showEventLabels(reverse: true)
            }
        }
    }
    
    func showEventLabels(reverse: Bool = false, completion: ((Bool) -> Void)? = nil) {
        let yOffset = reverse ? eventLabelOffset * -1 : eventLabelOffset
        
        UIView.animateWithDuration(dateTransitionTime, animations: { () -> Void in
            self.stateLabel.alpha       = 1
            self.countdownLabel.alpha   = 1
            self.dateLabel.alpha        = 1
            self.dateTimeScroller.alpha = 0.7
            self.huntingTimesView.frame = CGRectOffset(self.huntingTimesView.frame, 0, yOffset)
            self.huntingTimesView.alpha = 1.0
            }, completion)
    }
    
    func hideEventLabels(reverse: Bool = false, completion: ((Bool) -> Void)? = nil) {
        let yOffset = reverse ? eventLabelOffset * -1 : eventLabelOffset
        
        UIView.animateWithDuration(dateTransitionTime, animations: { () -> Void in
            self.stateLabel.alpha       = 0
            self.countdownLabel.alpha   = 0
            self.dateLabel.alpha        = 0
            self.dateTimeScroller.alpha = 0
            self.huntingTimesView.frame = CGRectOffset(self.huntingTimesView.frame, 0, yOffset)
            self.huntingTimesView.alpha = 0.0
            }) { (complete) -> Void in
                
                self.huntingTimesView.frame = CGRectOffset(self.huntingTimesView.frame, 0, yOffset * -2)
                if let completionClosure = completion {
                    completionClosure(complete)
                }
        }
    }
    
    func setNotifications() {
        huntingTimesView.removeAllNotifications()
        for (index, time) in enumerate(getHuntingTimes()) {
            let notifications = NotificationManager.sharedInstance.getAllNotificationsForKey(time.key())
            for notification in notifications {
                huntingTimesView.addNotificationIcon(time.time, animate: false)
            }
        }
    }
    
    /* End Action Methods */
    
    
    /* Delegate Methods */
    
    func willShowMessage() {
        self.countdownLabel.alpha = 0.0
    }
    
    func didHideMessage() {
        self.countdownLabel.alpha = 1.0
    }
    
    func didPositionIndicator(percent: CGFloat) {
        let totalDays  = huntingSeason.length()
        let currentDay = Int(round(CGFloat(totalDays - 1) * percent))
        huntingSeason.setCurrentDay(currentDay)
        datepickerLabel.text = currentTime().toDateString()
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
        messageLabel.addMessage(notification.getMessage())
        huntingTimesView.addNotificationIcon(notificationable.userInfo()["time"] as NSDate)
    }
    
    func didRemoveAllNotifications(notificationable: NotificationInterface) {
        let event = notificationable.userInfo()["event"] as String
        let time  = notificationable.userInfo()["time"] as NSDate
        messageLabel.addMessage("Removed All \(event) Notifications")
        huntingTimesView.removeNotificationIcons(time)
    }
    
    func didReceiveNotification(userInfo: [NSObject : AnyObject]) {
        let event = userInfo["event"] as String
        let time  = userInfo["time"] as NSDate
        
        huntingTimesView.removeNotificationIcon(time, event: event)
        
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
    func didTickCountdown() {
        dateTimeScroller.setPosition(huntingTimesProgress.getProgressPercent(), animate: true)
    }
    
    func willFinishCountdown() {
        UIView.animateWithDuration(0.5, delay: 0.9, options: nil, animations: { () -> Void in
            self.countdownLabel.alpha = 0.0
            }, completion: nil)
    }
    
    func didFinishCountdown() {
        setCountdownTime()
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.countdownLabel.alpha = 1.0
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
        if monthColumnView.hidden == false {
            for touch in touches {
                dateTimeScroller.setOffsetPosition((touch.locationInView(view).y - startScrollPosition.y))
                startScrollPosition = touch.locationInView(view)
            }
        }
    }
    
    /* End Touch Delegates */

    
    
    /* Interface Builders */
    
    func addBackground() {
        let bgImage = UIImage(named: "dark-forest.jpg")!
        bgImageView = TiltImageView(image: bgImage, frame: view.frame)
        view.addSubview(bgImageView)
        
        shadowView = ShadowView(frame: bgImageView.frame)
        shadowView.setDarkness(0.5)
        view.addSubview(shadowView)
    }
    
    func addMessageLabel() {
        messageLabel = MessageView(frame: CGRectMake(10, 75, view.frame.width - 20, 100))
        messageLabel.alpha    = 0.0
        messageLabel.delegate = self
        view.addSubview(messageLabel)
    }
    
    func addCountdown() {
        stateLabel = createLabel("", CGRectMake(0, 30, view.frame.width, 40), 16)
        stateLabel.font = UIFont(name: "HelveticaNeue", size: 16)
        stateLabel.alpha = 0.0
        view.addSubview(stateLabel)
        
        countdownLabel = CountdownView(frame: CGRectMake(0, 55, view.frame.width, 120))
        countdownLabel.alpha = 0.0
        view.addSubview(countdownLabel)
        
        countdownLabel.delegate = self
        
        setCountdownTime()
    }
    
    func addDateLabels() {
        dateLabel             = createLabel(currentTime().toDateString(), CGRectMake(0, 185, view.frame.width, 30), 18)
        dateLabel.alpha       = 0.0
        datepickerLabel       = createLabel(currentTime().toDateString(), CGRectMake(0, 60, view.frame.width, 120), 48)
        datepickerLabel.alpha = 0.0
        view.addSubview(dateLabel)
        view.addSubview(datepickerLabel)
    }
    
    func addHuntingTimesView() {
        huntingTimesView = HuntingTimesView(frame: CGRectMake(0, 210, view.frame.width, view.frame.height - 260))
        huntingTimesView.setDay(currentDay())
        huntingTimesView.alpha = 0.0
        huntingTimesView.delegate = self
        view.addSubview(huntingTimesView)
    }
    
    func addDateTimeScroller() {
        dateTimeScroller = ScrollLineView(frame: CGRectMake(view.frame.width / 2, 220, 1, view.frame.height - 260))
        dateTimeScroller.alpha           = 0.0
        dateTimeScroller.animateDuration = dateTransitionTime
        dateTimeScroller.delegate        = self
        view.addSubview(dateTimeScroller)
    }
    
    func addDatePicker() {
        monthColumnView = ColumnView(labels: ["September", "October", "November", "December"], frame: CGRectMake(0, 220, view.frame.width / 2.0 - 10, view.frame.height - 260))
        monthColumnView.setTextAlignment(NSTextAlignment.Right)
        monthColumnView.alpha  = 0.0
        monthColumnView.hidden = true
        view.addSubview(monthColumnView)
    }
    
    func addHints() {
        let downArrowImage  = UIImage(named: "down-arrow")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        downArrow           = UIImageView(image: downArrowImage)
        downArrow.center    = CGPointMake(view.frame.width / 2, view.frame.height - 20)
        downArrow.tintColor = .whiteColor()
        downArrow.alpha     = 0
        view.addSubview(downArrow)
        
        let upArrowImage  = UIImage(named: "up-arrow")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        upArrow           = UIImageView(image: upArrowImage)
        upArrow.center    = CGPointMake(view.frame.width / 2, dateTimeScroller.frame.origin.y - 35)
        upArrow.tintColor = .whiteColor()
        upArrow.alpha     = 0
        view.addSubview(upArrow)
        
        hintTapGesture  = UITapGestureRecognizer(target: self, action: "showSwipeHint")
        view.addGestureRecognizer(hintTapGesture)
    }
    
    func addDateGestures() {
        nextDateGesture           = UISwipeGestureRecognizer(target: self, action: "showPreviousDate")
        nextDateGesture.direction = .Up
        view.addGestureRecognizer(nextDateGesture)
        
        previousDateGesture           = UISwipeGestureRecognizer(target: self, action: "showNextDate")
        previousDateGesture.direction = .Down
        view.addGestureRecognizer(previousDateGesture)
        
        swipeRightGesture = UISwipeGestureRecognizer(target: self, action: "showPreviousDate")
        swipeRightGesture.direction = .Right
        swipeLeftGesture  = UISwipeGestureRecognizer(target: self, action: "showNextDate")
        swipeLeftGesture.direction = .Left
        
        view.addGestureRecognizer(swipeRightGesture)
        view.addGestureRecognizer(swipeLeftGesture)
    }
    
    /* End Interface Builders */
}

