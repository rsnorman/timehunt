//
//  HuntingPageController.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 1/3/15.
//  Copyright (c) 2015 Ryan Norman. All rights reserved.
//

import Foundation
import UIKit

class HuntingPageController : UIViewController {
    var huntingPageView      : HuntingPageView!
    var huntingDay           : HuntingDay
    let huntingPageClass     : HuntingPageView.Type
    var huntingTimesProgress : HuntingTimeProgress!
    
    init(huntingDay: HuntingDay, huntingPageClass: HuntingPageView.Type) {
        self.huntingDay       = huntingDay
        self.huntingPageClass = huntingPageClass
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        let frame = view.frame
        huntingPageView = huntingPageClass.init(frame: frame)
        huntingPageView.stateLabel.text = "Temperature"
        self.view = huntingPageView
        
        
        huntingTimesProgress = HuntingTimeProgress(huntingTimesColumn: getTimesColumn())
        
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setDay(huntingDay)
        super.viewWillAppear(animated)
    }
    
    func didSetDay(_ huntingDay: HuntingDay) {
        self.huntingDay = huntingDay
        huntingPageView?.huntingColumnsView.setDay(huntingDay)
        huntingTimesProgress?.huntingDay = huntingDay
    }
    
    func setDay(_ huntingDay: HuntingDay) {
        didSetDay(huntingDay)
    }
    
    func currentTime() -> HuntingTime {
        return huntingDay.getCurrentTime()
    }
    
    func currentProgress() -> CGFloat {
        return huntingTimesProgress.getProgressPercent()
    }
    
    func getTimesColumn() -> ColumnView {
        return huntingPageView.huntingColumnsView.leftColumnView
    }
    
    func startChangingDay(_ reverse: Bool = false, completion: ((_ reversing: Bool) -> Void)? = nil) {
        if huntingPageView.alpha != 0 {
            let labelOffset : CGFloat = 10.0
            let yOffset = reverse ? labelOffset * -1 : labelOffset
            
            UIView.animate(withDuration: DAY_TRANSITION_TIME, animations: { () -> Void in
                self.huntingPageView.alpha = 0
                self.huntingPageView.huntingColumnsView.frame = self.huntingPageView.huntingColumnsView.frame.offsetBy(dx: 0, dy: yOffset)
                self.huntingPageView.messageLabel
                }, completion: { (complete) -> Void in
                    
                    self.huntingPageView.huntingColumnsView.frame = self.huntingPageView.huntingColumnsView.frame.offsetBy(dx: 0, dy: yOffset * -2)
                    if let completionHandler = completion {
                        completionHandler(reverse)
                    }
            }) 
        } else {
            if let completionHandler = completion {
                completionHandler(reverse)
            }
        }
    }
    
    func finishChangingDay(_ reverse: Bool = false, completion: ((_ reversing: Bool) -> Void)? = nil) {
        let labelOffset: CGFloat = 10.0
        let yOffset = reverse ? labelOffset * -1 : labelOffset
        
        UIView.animate(withDuration: DAY_TRANSITION_TIME, animations: { () -> Void in
            self.huntingPageView.alpha = 1
            self.huntingPageView.huntingColumnsView.frame = self.huntingPageView.huntingColumnsView.frame.offsetBy(dx: 0, dy: yOffset)
            }, completion: { (complete) -> Void in
                
                if let completionHandler = completion {
                    completionHandler(reverse)
                }
        }) 
    }
}
