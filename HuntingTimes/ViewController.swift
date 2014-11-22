//
//  ViewController.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 11/21/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var bgImageView    : TiltImageView!
    var shadowView     : ShadowView!
    var huntStart      : String!
    var huntStop       : String!
    var states         : [String]!
    var events         : [String:String]!
    var countdownLabel : UILabel!
    var stateLabel     : UILabel!
    var stateLabels    : [String:UILabel]!
    var stateTimeLabels: [String:UILabel]!
    var stateIndicator : UIView!
    var timer          : NSTimer!

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
        
        huntStart  = "2014 Nov 22 9:33 AM"
        huntStop   = "2014 Nov 22 5:35 PM"
        
        let middleLine = UIView(frame: CGRectMake(view.frame.width / 2, 200, 1, view.frame.height - 250))
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
        view.addSubview(stateLabel)

        countdownLabel = createLabel("", frame: CGRectMake(0, 50, view.frame.width, 120), fontSize: 48)
        countdownLabel.numberOfLines = 2
        view.addSubview(countdownLabel)
        
        setCountdownTime()
    }
    
    func setCountdownTime() {
        stateLabel.text = events[currentState()]!
        
        highlightState()
        
        let timeLeft = currentTime().timeIntervalSinceNow
        println("Time Left: \(timeLeft)")
        let hours    = Int(ceil(timeLeft / 60) / 60)
        let minutes  = Int(ceil(timeLeft / 60) % 60)
        let seconds  = Int(timeLeft % 60)
        
        println("Hours: \(hours)")
        println("Minutes: \(minutes)")
        println("Seconds: \(seconds)")

        var countdownText = ""
        
        if hours > 0 {
            let hourLabel = hours > 1 ? "Hours" : "Hour"
            countdownText += "\(hours) \(hourLabel)"
        }
        
        if minutes > 1 {
            if hours > 1 {
                countdownText += "\n"
            }
            countdownText += "\(minutes) Minutes"
        }
            
        if hours == 0 && minutes == 1 {
            let secondLabel = seconds > 1 ? "Seconds" : "Second"
            countdownText += "\(seconds) \(secondLabel)"
        }
        
        countdownLabel.text = countdownText
        
        var delayInterval = NSTimeInterval(hours > 0 || minutes > 1 ? seconds + 1 : 1)
        delayInterval = delayInterval == 0 ? 60 : delayInterval
        println("Delay Interval: \(delayInterval)")
        createTimer(delayInterval)
    }
    
    func createTimer(delayInterval : NSTimeInterval) {
        timer = NSTimer.scheduledTimerWithTimeInterval(delayInterval, target: self, selector: "setCountdownTime", userInfo: nil, repeats: false)
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
            
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                self.stateIndicator.center = CGPointMake(self.stateIndicator.center.x, stateLabel.center.y)
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
        let eventLabel = createLabel(text, frame: CGRectMake(0, y, view.frame.width / 2 - 10, 30), fontSize: 24)
        eventLabel.textAlignment = .Right
        view.addSubview(eventLabel)
        
        return eventLabel
    }
    
    func addEventTimeLabel(text: String, y: CGFloat) -> UILabel {
        let eventTimeLabel = createLabel(text, frame: CGRectMake(view.frame.width / 2 + 10, y, view.frame.width / 2 - 10, 30), fontSize: 24)
        eventTimeLabel.textAlignment = .Left
        view.addSubview(eventTimeLabel)
        
        return eventTimeLabel
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

