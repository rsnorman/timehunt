//
//  ViewController.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 11/21/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CountdownViewDelegate {
    var bgImageView    : TiltImageView!
    var shadowView     : ShadowView!
    var states         : [String]!
    var events         : [String:String]!
    var countdownLabel : CountdownView!
    var stateLabel     : UILabel!
    var reversing      : Bool!
    var animating      : Bool!
    var dateLabel      : UILabel!
    var downArrow      : UIImageView!
    var upArrow        : UIImageView!
    var huntingTimes   : HuntingTimes!
    var monthLabels    : [UILabel]!
    var scrollingDates : Bool!
    let dateTransitionTime:Double = 0.7
    let eventLabelOffset:CGFloat  = 10.0
    
    var dateTimeScroller : ScrollLineView!
    var huntingTimesView : HuntingTimesView!
    var monthColumnView  : ColumnView!
    
    var huntingTimesProgress : HuntingTimeProgress!
    
    var nextDateGesture: UISwipeGestureRecognizer!
    var previousDateGesture: UISwipeGestureRecognizer!
    var swipeRightGesture: UISwipeGestureRecognizer!
    var swipeLeftGesture: UISwipeGestureRecognizer!
    var panDatesGesture: UIPanGestureRecognizer!
    var hintTapGesture: UITapGestureRecognizer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        StatusBarUpdater.white(animated: false)
        
        states = ["Start", "Sunrise", "Sunset", "Stop", "Ended"]
        events = [
            "starting"   : "Start",
            "sunrising"  : "Sunrise",
            "sunsetting" : "Sunset",
            "ending"     : "Stop",
            "ended"      : "Ended"
        ]
        
        let bgImage = UIImage(named: "dark-forest.jpg")!
        bgImageView = TiltImageView(image: bgImage, frame: view.frame)
        view.addSubview(bgImageView)
        
        shadowView = ShadowView(frame: bgImageView.frame)
        view.addSubview(shadowView)
        
        reversing = false
        animating = false
        
        huntingTimes = HuntingTimes()
        
        dateTimeScroller = ScrollLineView(frame: CGRectMake(view.frame.width / 2, 220, 1, view.frame.height - 240))
        dateTimeScroller.alpha           = 0.0
        dateTimeScroller.animateDuration = dateTransitionTime
        view.addSubview(dateTimeScroller)
        
        huntingTimesView = HuntingTimesView(frame: CGRectMake(0, 210, view.frame.width, view.frame.height - 240))
        huntingTimesView.setTimes(getHuntingTimes())
        huntingTimesView.alpha = 0.0
        view.addSubview(huntingTimesView)
        
        monthColumnView = ColumnView(labels: ["September", "October", "November", "December"], frame: CGRectMake(0, 220, view.frame.width / 2.0 - 10, view.frame.height - 240))
        monthColumnView.setTextAlignment(NSTextAlignment.Right)
        monthColumnView.alpha  = 0.0
        monthColumnView.hidden = true
        view.addSubview(monthColumnView)
        
        huntingTimesProgress = HuntingTimeProgress(huntingTimes: getHuntingTimes(), huntingTimesColumn: huntingTimesView.timeColumnView)
        
        dateLabel       = createLabel(dateToString(currentTime()), frame: CGRectMake(0, 185, view.frame.width, 30), fontSize: 18)
        dateLabel.alpha = 0.0
        view.addSubview(dateLabel)
        
        let downArrowImage  = UIImage(named: "down-arrow")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        downArrow           = UIImageView(image: downArrowImage)
        downArrow.center    = CGPointMake(view.frame.width / 2, view.frame.height - 20)
        downArrow.tintColor = .whiteColor()
        downArrow.alpha     = 0
        view.addSubview(downArrow)
        
        let upArrowImage  = UIImage(named: "up-arrow")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        upArrow           = UIImageView(image: upArrowImage)
        upArrow.center    = CGPointMake(view.frame.width / 2, dateTimeScroller.frame.origin.y - 40)
        upArrow.tintColor = .whiteColor()
        upArrow.alpha     = 0
        view.addSubview(upArrow)
        
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
        
        hintTapGesture  = UITapGestureRecognizer(target: self, action: "showSwipeHint")
        view.addGestureRecognizer(swipeRightGesture)
        view.addGestureRecognizer(swipeLeftGesture)
        view.addGestureRecognizer(hintTapGesture)

        scrollingDates = false
        
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
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        scrollingDates = true
        delay(0.3) {
            if self.scrollingDates == true {
                self.startScrollDates()
            }
        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        scrollingDates = false
        delay(0.3) {
            self.stopScrollDates()
        }
    }
    
    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
        scrollingDates = false
        delay(0.3) {
            self.stopScrollDates()
        }
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        if scrollingDates == true {
            for touch in touches {
//                println(touch.locationInView(view).y)
            }
        }
    }
    
    func startScrollDates() {
        if monthColumnView.hidden == true {
            nextDateGesture.enabled = false
            previousDateGesture.enabled = false
            swipeLeftGesture.enabled = false
            swipeRightGesture.enabled = false
            hintTapGesture.enabled = false
            monthColumnView.hidden = false
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.huntingTimesView.alpha = 0.0
            }) { (complete) -> Void in
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.monthColumnView.alpha = 1.0
                })
            }
        }
    }
    
    func stopScrollDates() {
        if monthColumnView.hidden == false {
            nextDateGesture.enabled = true
            previousDateGesture.enabled = true
            swipeLeftGesture.enabled = true
            swipeRightGesture.enabled = true
            hintTapGesture.enabled = true
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.monthColumnView.alpha = 0.0
            }) { (complete) -> Void in
                self.monthColumnView.hidden = true
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.huntingTimesView.alpha = 1.0
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
    
    func currentState() -> String {
        if startTime().timeIntervalSinceNow > 0 {
            return "starting"
        } else if sunriseTime().timeIntervalSinceNow > 0 {
            return "sunrising"
        } else if sunsetTime().timeIntervalSinceNow > 0 {
            return "sunsetting"
        } else if stopTime().timeIntervalSinceNow > 0 {
            return "ending"
        } else {
            return "ended"
        }
    }
    
    func setTimes() {
        huntingTimesView.setTimes(getHuntingTimes())
        huntingTimesProgress.huntingTimes = getHuntingTimes()
        dateLabel.text = dateToString(currentTime())
    }
    
    func getHuntingTimes() -> [NSDate] {
        return [startTime(), sunriseTime(), sunsetTime(), endTime()]
    }
    
    func addCountdown() {
        stateLabel = createLabel("", frame: CGRectMake(0, 30, view.frame.width, 40), fontSize: 16)
        stateLabel.font = UIFont(name: "HelveticaNeue", size: 16)
        stateLabel.alpha = 0.0
        view.addSubview(stateLabel)

        countdownLabel = CountdownView(frame: CGRectMake(0, 50, view.frame.width, 120))
        countdownLabel.alpha = 0.0
        view.addSubview(countdownLabel)
        
        countdownLabel.delegate = self
        
        setCountdownTime()
    }
    
    func setCountdownTime() {
        countdownLabel.stopCountdown()
        if currentTime().timeIntervalSinceNow > 0 {
            countdownLabel.startCountdown(currentTime())
            stateLabel.text = events[currentState()]!
        } else {
            stateLabel.text = ""
            dateTimeScroller.setPosition(1, animate: true)
        }
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
    
    func currentTime() -> NSDate {
        let times = [
            "starting"   : startTime(),
            "sunrising"  : sunriseTime(),
            "sunsetting" : sunsetTime(),
            "ending"     : stopTime(),
            "ended"      : endTime()
        ]
        
        return times[currentState()]!
    }
    
    func startTime() -> NSDate {
        return huntingTimes.current().startTime
    }
    
    func sunriseTime() -> NSDate {
        return startTime().dateByAddingTimeInterval(60 * 60)
    }
    
    func sunsetTime() -> NSDate {
        return stopTime().dateByAddingTimeInterval(60 * 30 * -1)
    }
    
    func stopTime() -> NSDate {
        return huntingTimes.current().endTime
    }
    
    func endTime() -> NSDate {
        return stopTime()
    }
    
    func timeLeft(dateTime: NSDate) -> NSTimeInterval {
        return dateTime.timeIntervalSinceNow
    }
    
    func addEventTimeLabel(text: String, y: CGFloat) -> UILabel {
        let eventTimeLabel = createLabel(text, frame: CGRectMake(view.frame.width / 2 + 10, y - eventLabelOffset, view.frame.width / 2 - 10, 30), fontSize: 24)
        eventTimeLabel.textAlignment = .Left
        eventTimeLabel.alpha         = 0
        
        view.addSubview(eventTimeLabel)
        
        return eventTimeLabel
    }
    
    func showNextDate() {
        if !animating && !huntingTimes.last() {
            animating = true
            reversing = false
            self.dateTimeScroller.setPosition(1, animate: true)
            hideEventLabels(reverse: false) { (complete) -> Void in
                self.animating = false
                self.huntingTimes.next()
                self.setTimes()
                self.dateTimeScroller.setPosition(0, animate: false)
                self.setCountdownTime()
                self.showEventLabels(reverse: false)
            }
        }
    }
    
    func showPreviousDate() {
        if !animating && !huntingTimes.first() {
            animating = true
            reversing = true
            self.dateTimeScroller.setPosition(0, animate: true)
            hideEventLabels(reverse: true) { (complete) -> Void in
                self.animating = false
                self.huntingTimes.previous()
                self.setTimes()
                self.dateTimeScroller.setPosition(1, animate: false)
                self.setCountdownTime()
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
    
    func createLabel(text: String, frame: CGRect, fontSize: CGFloat) -> UILabel {
        let label = UILabel(frame: frame)
        label.text = text
        label.textColor = .whiteColor()
        label.font = UIFont(name: "HelveticaNeue-Thin", size: fontSize)
        label.textAlignment = .Center
        
        return label
    }
}

