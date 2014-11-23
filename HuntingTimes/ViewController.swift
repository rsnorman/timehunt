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
    var huntStart      : String!
    var huntStop       : String!
    var states         : [String]!
    var events         : [String:String]!
    var countdownLabel : CountdownView!
    var stateLabel     : UILabel!
    var stateLabels    : [String:UILabel]!
    var stateTimeLabels: [String:UILabel]!
    var stateIndicator : UIView!
    var middleLine     : UIView!
    var dates          : [[String:String]]!
    var currentPosition: Int!
    var reversing      : Bool!
    var animating      : Bool!
    var dateLabel      : UILabel!
    var downArrow      : UIImageView!
    var upArrow        : UIImageView!
    
    let eventLabelOffset:CGFloat = 10.0

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
        
        let bgImage = UIImage(named: "forest.jpg")!
        bgImageView = TiltImageView(image: bgImage, frame: view.frame)
        view.addSubview(bgImageView)
        
        shadowView = ShadowView(frame: bgImageView.frame)
        view.addSubview(shadowView)
        
        currentPosition = 1
        reversing       = false
        animating       = false
        dates           = HuntingTimeParser.parse()
        
        huntStart = dates[currentPosition]["start"]!
        huntStop  = dates[currentPosition]["stop"]!
        
        middleLine = UIView(frame: CGRectMake(view.frame.width / 2, 220, 1, view.frame.height - 240))
        middleLine.backgroundColor = .whiteColor()
        middleLine.alpha           = 0.0
        view.addSubview(middleLine)
        
        stateIndicator = UIView(frame: CGRectMake(view.frame.width / 2 - 5, 240, 11, 11))
        stateIndicator.layer.cornerRadius = 5.5
        stateIndicator.layer.borderColor  = UIColor.whiteColor().CGColor
        stateIndicator.layer.borderWidth  = 1
        stateIndicator.backgroundColor    = .whiteColor()
        stateIndicator.alpha              = 0.0
        view.addSubview(stateIndicator)
        
        stateLabels               = [:]
        stateLabels["starting"]   = addEventLabel("Start",   y: 245)
        stateLabels["sunrising"]  = addEventLabel("Sunrise", y: 325)
        stateLabels["sunsetting"] = addEventLabel("Sunset",  y: 405)
        stateLabels["ending"]     = addEventLabel("Stop",    y: 485)
        
        stateTimeLabels               = [:]
        stateTimeLabels["starting"]   = addEventTimeLabel(timeToString(startTime()),   y: 245)
        stateTimeLabels["sunrising"]  = addEventTimeLabel(timeToString(sunriseTime()), y: 325)
        stateTimeLabels["sunsetting"] = addEventTimeLabel(timeToString(sunsetTime()),  y: 405)
        stateTimeLabels["ending"]     = addEventTimeLabel(timeToString(stopTime()),    y: 485)
        
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
        upArrow.center    = CGPointMake(view.frame.width / 2, middleLine.frame.origin.y - 40)
        upArrow.tintColor = .whiteColor()
        upArrow.alpha     = 0
        view.addSubview(upArrow)
        
        let nextDateGesture       = UISwipeGestureRecognizer(target: self, action: "showPreviousDate")
        nextDateGesture.direction = .Up
        view.addGestureRecognizer(nextDateGesture)
        
        let previousDateGesture       = UISwipeGestureRecognizer(target: self, action: "showNextDate")
        previousDateGesture.direction = .Down
        view.addGestureRecognizer(previousDateGesture)
        
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: "showPreviousDate")
        swipeRightGesture.direction = .Right
        let swipeLeftGesture  = UISwipeGestureRecognizer(target: self, action: "showNextDate")
        swipeLeftGesture.direction = .Left
        let touchDownGesture  = UITapGestureRecognizer(target: self, action: "showSwipeHint")
        view.addGestureRecognizer(swipeRightGesture)
        view.addGestureRecognizer(swipeLeftGesture)
        view.addGestureRecognizer(touchDownGesture)
        
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
                    self.upArrow.frame = CGRectOffset(self.upArrow.frame, 0, 10)
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
        huntStart  = dates[currentPosition]["start"]!
        huntStop   = dates[currentPosition]["stop"]!
        stateTimeLabels["starting"]?.text   = timeToString(startTime())
        stateTimeLabels["sunrising"]?.text  = timeToString(sunriseTime())
        stateTimeLabels["sunsetting"]?.text = timeToString(sunsetTime())
        stateTimeLabels["ending"]?.text     = timeToString(stopTime())
        
        dateLabel.text = dateToString(currentTime())
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
        highlightState()
        countdownLabel.stopCountdown()
        if currentTime().timeIntervalSinceNow > 0 {
            countdownLabel.startCountdown(currentTime())
            stateLabel.text = events[currentState()]!
        } else {
            stateLabel.text = ""
        }
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
    
    func highlightState() {
        for (state, label) in stateLabels {
            label.layer.shadowOpacity = 0.0
        }
        
        for (state, label) in stateTimeLabels {
            label.layer.shadowOpacity = 0.0
        }
        
        if let stateLabel = stateLabels[currentState()] {
            stateLabel.layer.shadowColor = UIColor.whiteColor().CGColor
            stateLabel.layer.shadowOpacity = 0.8
            
            let indicatorYOffset = reversing == true ? eventLabelOffset * -1 : eventLabelOffset
            UIView.animateWithDuration(1.0, animations: { () -> Void in
                self.stateIndicator.center = CGPointMake(self.stateIndicator.center.x, stateLabel.center.y + indicatorYOffset)
            })
        }
        
        if let stateTimeLabel = stateTimeLabels[currentState()] {
            stateTimeLabel.layer.shadowColor = UIColor.whiteColor().CGColor
            stateTimeLabel.layer.shadowOpacity = 0.8
        }
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
        return parseTime(huntStart)
    }
    
    func sunriseTime() -> NSDate {
        return startTime().dateByAddingTimeInterval(60 * 60)
    }
    
    func sunsetTime() -> NSDate {
        return stopTime().dateByAddingTimeInterval(60 * 30 * -1)
    }
    
    func stopTime() -> NSDate {
        return parseTime(huntStop)
    }
    
    func endTime() -> NSDate {
        return stopTime()
    }
    
    func parseTime(timeString: String) -> NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY MMM d h:mm a"
        
        return dateFormatter.dateFromString(timeString)!
    }
    
    func dateToString(dateTime: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMMM d"
        let dateString = dateFormatter.stringFromDate(dateTime)
        
        if dateFormatter.stringFromDate(NSDate()) == dateString {
            return "Today"
        } else if dateTime.timeIntervalSinceNow < 0 && dateTime.timeIntervalSinceNow > -60 * 60 * 24 {
            return "Yesterday"
        } else if dateTime.timeIntervalSinceNow > 0 && dateTime.timeIntervalSinceNow < 60 * 60 * 24 {
            return "Tomorrow"
        }
        
        return dateString
    }
    
    func timeToString(dateTime: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "h:mm"
        
        return dateFormatter.stringFromDate(dateTime)
    }
    
    func timeLeft(dateTime: NSDate) -> NSTimeInterval {
        return dateTime.timeIntervalSinceNow
    }
    
    func addEventLabel(text: String, y: CGFloat) -> UILabel {
        let eventLabel = createLabel(text, frame: CGRectMake(0, y - 10, view.frame.width / 2 - eventLabelOffset, 30), fontSize: 24)
        eventLabel.textAlignment = .Right
        eventLabel.alpha         = 0
        
        view.addSubview(eventLabel)
        
        return eventLabel
    }
    
    func addEventTimeLabel(text: String, y: CGFloat) -> UILabel {
        let eventTimeLabel = createLabel(text, frame: CGRectMake(view.frame.width / 2 + 10, y - eventLabelOffset, view.frame.width / 2 - 10, 30), fontSize: 24)
        eventTimeLabel.textAlignment = .Left
        eventTimeLabel.alpha         = 0
        
        view.addSubview(eventTimeLabel)
        
        return eventTimeLabel
    }
    
    func showNextDate() {
        if !animating && currentPosition < dates.count - 1 {
            animating = true
            reversing = false
            hideEventLabels(reverse: false) { (complete) -> Void in
                self.animating = false
                self.currentPosition = self.currentPosition + 1
                self.setTimes()
                self.setCountdownTime()
                self.highlightState()
                self.showEventLabels(reverse: false)
            }
        }
    }
    
    func showPreviousDate() {
        if !animating && currentPosition > 0 {
            animating = true
            reversing = true
            hideEventLabels(reverse: true) { (complete) -> Void in
                self.animating = false
                self.currentPosition = self.currentPosition - 1
                self.setTimes()
                self.setCountdownTime()
                self.highlightState()
                self.showEventLabels(reverse: true)
            }
        }
    }
    
    func showEventLabels(reverse: Bool = false, completion: ((Bool) -> Void)? = nil) {
        let yOffset = reverse ? eventLabelOffset * -1 : eventLabelOffset
        UIView.animateWithDuration(1.0, animations: { () -> Void in
            for (state, label) in self.stateLabels {
                label.frame = CGRectOffset(label.frame, 0, yOffset)
                label.alpha = 1
            }
            
            for (state, label) in self.stateTimeLabels {
                label.frame = CGRectOffset(label.frame, 0, yOffset)
                label.alpha = 1
            }
            
            self.stateLabel.alpha     = 1
            self.countdownLabel.alpha = 1
            self.dateLabel.alpha      = 1
            self.stateIndicator.alpha = 0.7
            self.middleLine.alpha     = 0.7
        }, completion)
    }
    
    func hideEventLabels(reverse: Bool = false, completion: ((Bool) -> Void)? = nil) {
        let yOffset = reverse ? eventLabelOffset * -1 : eventLabelOffset
        UIView.animateWithDuration(1.0, animations: { () -> Void in
            
            for (state, label) in self.stateLabels {
                label.layer.shadowOpacity = 0.0
                label.frame = CGRectOffset(label.frame, 0, yOffset)
                label.alpha = 0
            }
            
            for (state, label) in self.stateTimeLabels {
                label.layer.shadowOpacity = 0.0
                label.frame = CGRectOffset(label.frame, 0, yOffset)
                label.alpha = 0
            }
            
            self.stateLabel.alpha     = 0
            self.countdownLabel.alpha = 0
            self.dateLabel.alpha      = 0
            self.stateIndicator.alpha = 0
        }) { (complete) -> Void in
            for (state, label) in self.stateLabels {
                label.frame = CGRectOffset(label.frame, 0, yOffset * -2)
            }
            
            for (state, label) in self.stateTimeLabels {
                label.frame = CGRectOffset(label.frame, 0, yOffset * -2)
            }
            let indicatorYOffset = reverse ? self.middleLine.frame.origin.y + self.middleLine.frame.height : self.middleLine.frame.origin.y
            self.stateIndicator.center = CGPointMake(self.stateIndicator.center.x, indicatorYOffset)
            
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

