//
//  MainViewAnimations.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 11/28/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import UIKit

class MainViewAnimations : NSObject {
    let mainView          : MainView
    let eventLabelOffset  : CGFloat = 10.0
    private var animating : Bool = false
    
    init(mainView: MainView) {
        self.mainView = mainView
    }
    
    func isAnimating() -> Bool {
        return animating
    }
    
    func hideDailyView(completion: ((Bool) -> Void)?) {
        if !animating {
            animating = true
            for gesture in mainView.superview!.gestureRecognizers as [UIGestureRecognizer] {
                gesture.enabled = false
            }
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.mainView.dateTimeScroller.showCurrentPosition()
                self.mainView.hideDailyView(hideIndicator: false)
                
                self.mainView.showHints()
            }) { (complete) -> Void in
                self.animating = false
                completion?(complete)
            }
        }
    }
    
    func showDailyView() {
        if !animating {
            animating = true
            for gesture in mainView.superview!.gestureRecognizers as [UIGestureRecognizer] {
                gesture.enabled = true
            }
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.animating = false
                self.mainView.showDailyView()
            })
        }
    }
    
    func showHuntingTimes(reverse: Bool = false, completion: ((reversing: Bool, complete: Bool) -> Void)? = nil) {
        if !animating {
            animating = true
            let yOffset = reverse ? eventLabelOffset * -1 : eventLabelOffset
            
            UIView.animateWithDuration(DAY_TRANSITION_TIME, animations: { () -> Void in
                self.mainView.showDailyView()
                self.mainView.huntingTimesView.frame = CGRectOffset(self.mainView.huntingTimesView.frame, 0, yOffset)
            }) { (complete) -> Void in
                self.animating = false
                completion?(reversing: reverse, complete: complete)
            }
        }
    }
    
    func hideHuntingTimes(reverse: Bool = false, completion: ((reversing: Bool, complete: Bool) -> Void)? = nil) {
        if !animating {
            animating = true
            let yOffset = reverse ? eventLabelOffset * -1 : eventLabelOffset
            
            UIView.animateWithDuration(DAY_TRANSITION_TIME, animations: { () -> Void in
                self.mainView.hideDailyView()
                self.mainView.huntingTimesView.frame = CGRectOffset(self.mainView.huntingTimesView.frame, 0, yOffset)
            }) { (complete) -> Void in
                self.animating = false
                self.mainView.huntingTimesView.frame = CGRectOffset(self.mainView.huntingTimesView.frame, 0, yOffset * -2)
                completion?(reversing: reverse, complete: complete)
            }
        }
    }
    
    func showDatePicker(percentComplete: CGFloat) {
        if !animating {
            animating = true
            mainView.countdownLabel.stopCountdown()
            mainView.monthColumnView.hidden = false
            mainView.datepickerLabel.text   = self.mainView.dateLabel.text
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.animating = false
                self.mainView.dateTimeScroller.setPosition(percentComplete, animate: false)
                self.mainView.showDatePicker()
                }) { (complete) -> Void in
                    self.animating = false
            }
        }
    }
    
    func hideDatePicker(completion: ((complete: Bool) -> Void)?) {
        if !animating {
            animating = true
            UIView.animateWithDuration(0.3, delay: 0.1, options: nil, animations: { () -> Void in
                self.mainView.hideDatePicker()
                self.mainView.dateTimeScroller.hideCurrentPosition()
                self.mainView.hideHints()
            }) { (complete) -> Void in
                self.animating = false
                self.mainView.resetHints()
                self.mainView.monthColumnView.hidden = true
                completion?(complete: complete)
            }
        }
    }
    
    func slideOutDailyView(completion: ((complete: Bool) -> Void)?) {
        if !animating {
            animating = true
            let frame = self.mainView.huntingTimesView.frame
            
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                let frame = self.mainView.huntingTimesView.frame
                self.mainView.huntingTimesView.frame = CGRectOffset(frame, -20, 0)
                self.mainView.huntingTimesView.alpha = 0.0
            }) { (complete) -> Void in
                let wFrame = self.mainView.huntingWeatherView.frame
                self.mainView.huntingWeatherView.frame = CGRectOffset(wFrame, 20, 0)
                self.mainView.huntingTimesView.frame = CGRectOffset(frame, 0, 0)
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.mainView.huntingWeatherView.alpha = 1.0
                    self.mainView.huntingWeatherView.frame = CGRectOffset(wFrame, 0, 0)
                }) { (complete) -> Void in
                    self.animating = false
                }
            }
        }
    }
    
    func slideInDailyView(completion: ((complete: Bool) -> Void)?) {
        if !animating {
            animating = true
            let frame = self.mainView.huntingWeatherView.frame
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.mainView.huntingWeatherView.frame = CGRectOffset(frame, 20, 0)
                self.mainView.huntingWeatherView.alpha = 0.0
                }) { (complete) -> Void in
                    let wFrame = self.mainView.huntingTimesView.frame
                    self.mainView.huntingTimesView.frame = CGRectOffset(wFrame, -20, 0)
                    self.mainView.huntingWeatherView.frame = CGRectOffset(frame, 0, 0)
                    UIView.animateWithDuration(0.2, animations: { () -> Void in
                        self.mainView.huntingTimesView.alpha = 1.0
                        self.mainView.huntingTimesView.frame = CGRectOffset(wFrame, 0, 0)
                    }) { (complete) -> Void in
                        self.animating = false
                    }
            }
        }
    }
    
    func showSwipeHint() {
        if !animating {
            animating = true
            UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                self.mainView.showHints()
            }) { (complete) -> Void in
                UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                    self.mainView.hideHints()
                }, completion: { (complete) -> Void in
                    self.animating = false
                    self.mainView.resetHints()
                })
            }
        }
    }
}