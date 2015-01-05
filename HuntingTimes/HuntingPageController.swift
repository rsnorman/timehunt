//
//  HuntingPageController.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 1/3/15.
//  Copyright (c) 2015 Ryan Norman. All rights reserved.
//

import Foundation

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
        huntingPageView = huntingPageClass(frame: frame)
        huntingPageView.stateLabel.text = "Temperature"
        self.view = huntingPageView
        
        
        huntingTimesProgress = HuntingTimeProgress(huntingTimesColumn: getTimesColumn())
        
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        setDay(huntingDay)
        super.viewWillAppear(animated)
    }
    
    func didSetDay(huntingDay: HuntingDay) {
        self.huntingDay = huntingDay
        huntingPageView?.huntingColumnsView.setDay(huntingDay)
        huntingTimesProgress?.huntingDay = huntingDay
    }
    
    func setDay(huntingDay: HuntingDay) {
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
    
    func startChangingDay(reverse: Bool = false, completion: ((reversing: Bool) -> Void)? = nil) {
        let labelOffset : CGFloat = 10.0
        let yOffset = reverse ? labelOffset * -1 : labelOffset
        
        UIView.animateWithDuration(DAY_TRANSITION_TIME, animations: { () -> Void in
            self.huntingPageView.alpha = 0
            self.huntingPageView.huntingColumnsView.frame = CGRectOffset(self.huntingPageView.huntingColumnsView.frame, 0, yOffset)
            }) { (complete) -> Void in
                
                self.huntingPageView.huntingColumnsView.frame = CGRectOffset(self.huntingPageView.huntingColumnsView.frame, 0, yOffset * -2)
                if let completionHandler = completion {
                    completionHandler(reversing: reverse)
                }
        }
    }
    
    func finishChangingDay(reverse: Bool = false, completion: ((reversing: Bool) -> Void)? = nil) {
        let labelOffset: CGFloat = 10.0
        let yOffset = reverse ? labelOffset * -1 : labelOffset
        
        UIView.animateWithDuration(DAY_TRANSITION_TIME, animations: { () -> Void in
            self.huntingPageView.alpha = 1
            self.huntingPageView.huntingColumnsView.frame = CGRectOffset(self.huntingPageView.huntingColumnsView.frame, 0, yOffset)
            }) { (complete) -> Void in
                
                if let completionHandler = completion {
                    completionHandler(reversing: reverse)
                }
        }
    }
}
