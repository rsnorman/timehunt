//
//  CountdownView.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 11/22/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import UIKit

protocol CountdownViewDelegate {
    func willFinishCountdown()
    func didFinishCountdown()
    func didTickCountdown()
}

class CountdownLabel : UILabel {
    var countdownToTime : Date!
    var delegate        : CountdownViewDelegate!
    var timer           : Timer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        text          = ""
        textColor     = .white
        font          = UIFont(name: "HelveticaNeue-Thin", size: 48)
        textAlignment = .center
        numberOfLines = 2
    }
    
    func startCountdown(_ countdownToTime: Date) {
        self.countdownToTime = countdownToTime
        updateCountdown()
    }
    
    func stopCountdown() {
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
        text = "Ended"
    }
    
    @objc func updateCountdown() {
        let timeLeft = countdownToTime.timeIntervalSinceNow
        let hours    = Int(ceil(timeLeft / 60) / 60)
        let minutes  = Int(ceil(timeLeft / 60).truncatingRemainder(dividingBy: 60))
        let seconds  = Int(timeLeft.truncatingRemainder(dividingBy: 60))
        
        var countdownText = ""
        
        if hours > 48 {
            countdownText = "\(Int(ceil(Double(hours) / 24))) Days"
        } else {
            if hours > 0 {
                let hourLabel = hours > 1 ? "Hours" : "Hour"
                countdownText += "\(hours) \(hourLabel)"
            }
            
            if minutes > 1 {
                if hours >= 1 {
                    countdownText += "\n"
                }
                countdownText += "\(minutes) Minutes"
            }
            
            if hours == 0 && minutes == 1 {
                let secondLabel = seconds > 1 ? "Seconds" : "Second"
                countdownText += "\(seconds) \(secondLabel)"
            }
        }
        
        text = countdownText
        
        if let del = delegate {
            del.didTickCountdown()
        }
        
        if (hours > 0 || minutes > 0 || seconds > 0) {
            var delayInterval = TimeInterval(hours > 0 || minutes > 1 ? seconds + 1 : 1)
            delayInterval = delayInterval == 0 ? 60 : delayInterval
            
            timer = Timer.scheduledTimer(timeInterval: delayInterval, target: self, selector: #selector(CountdownLabel.updateCountdown), userInfo: nil, repeats: false)
            
            if hours == 0 && minutes == 1 && seconds == 1 {
                if let del = delegate {
                    del.willFinishCountdown()
                }
            }
        } else {
            if let del = delegate {
                del.didFinishCountdown()
            }
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
