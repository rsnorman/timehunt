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
    
    let eventLabelOffset:CGFloat = 10.0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        StatusBarUpdater.white(animated: false)
        
        states = ["Start", "Sunrise", "Sunset", "Stop"]
        events = [
            "starting"   : "Start",
            "sunrising"  : "Sunrise",
            "sunsetting" : "Sunset",
            "ending"     : "Stop"
        ]
        
        let bgImage = UIImage(named: "forest.jpg")!
        bgImageView = TiltImageView(image: bgImage, frame: view.frame)
        view.addSubview(bgImageView)
        
        shadowView = ShadowView(frame: bgImageView.frame)
        view.addSubview(shadowView)
        
        huntStart  = "2014 Nov 22 7:02 AM"
        huntStop   = "2014 Nov 22 5:35 PM"
        
        middleLine = UIView(frame: CGRectMake(view.frame.width / 2, 200, 1, view.frame.height - 250))
        middleLine.backgroundColor = .whiteColor()
        middleLine.alpha           = 0.7
        view.addSubview(middleLine)
        
        stateIndicator = UIView(frame: CGRectMake(view.frame.width / 2 - 5, 220, 11, 11))
        stateIndicator.layer.cornerRadius = 5.5
        stateIndicator.layer.borderColor  = UIColor.whiteColor().CGColor
        stateIndicator.layer.borderWidth  = 1
        stateIndicator.backgroundColor    = .whiteColor()
        stateIndicator.alpha              = 0.7
        view.addSubview(stateIndicator)
        
        stateLabels               = [:]
        stateLabels["starting"]   = addEventLabel("Start", y: 220)
        stateLabels["sunrising"]  = addEventLabel("Sunrise", y: 300)
        stateLabels["sunsetting"] = addEventLabel("Sunset", y: 380)
        stateLabels["ending"]     = addEventLabel("Stop", y: 460)
        
        stateTimeLabels               = [:]
        stateTimeLabels["starting"]   = addEventTimeLabel(dateToString(startTime()), y: 220)
        stateTimeLabels["sunrising"]  = addEventTimeLabel(dateToString(sunriseTime()), y: 300)
        stateTimeLabels["sunsetting"] = addEventTimeLabel(dateToString(sunsetTime()), y: 380)
        stateTimeLabels["ending"]     = addEventTimeLabel(dateToString(stopTime()), y: 460)
        
        addCountdown()
        
        let nextDateGesture = UISwipeGestureRecognizer(target: self, action: "showNextDate")
        nextDateGesture.direction = .Down
        view.addGestureRecognizer(nextDateGesture)
        
        let previousDateGesture = UISwipeGestureRecognizer(target: self, action: "showPreviousDate")
        previousDateGesture.direction = .Up
        view.addGestureRecognizer(previousDateGesture)
    }
    
    override func viewDidAppear(animated: Bool) {
        showEventLabels()
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
        stateLabel.text = events[currentState()]!
        highlightState()
        countdownLabel.startCountdown(currentTime())
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
            
            UIView.animateWithDuration(1.0, animations: { () -> Void in
                self.stateIndicator.center = CGPointMake(self.stateIndicator.center.x, stateLabel.center.y + self.eventLabelOffset)
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
            "ending"     : stopTime()
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
    
    func parseTime(timeString: String) -> NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY MMM d h:mm a"
        
        return dateFormatter.dateFromString(timeString)!
    }
    
    func dateToString(dateTime: NSDate) -> String {
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
        hideEventLabels(reverse: false) { (complete) -> Void in
            self.highlightState()
            self.showEventLabels()
        }
    }
    
    func showPreviousDate() {
        hideEventLabels(reverse: true) { (complete) -> Void in
            self.highlightState()
            self.showEventLabels(reverse: true)
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
            self.stateIndicator.alpha = 1
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

