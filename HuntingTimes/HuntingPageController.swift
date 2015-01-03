//
//  HuntingPageController.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 1/3/15.
//  Copyright (c) 2015 Ryan Norman. All rights reserved.
//

import Foundation

class HuntingPageController : UIViewController {
    var huntingPageView : HuntingPageView
    var huntingDay      : HuntingDay
    
    init(huntingDay: HuntingDay, huntingPageView: HuntingPageView) {
        self.huntingDay      = huntingDay
        self.huntingPageView = huntingPageView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        setDay(huntingDay)
        self.view = huntingPageView
        super.viewDidLoad()
    }
    
    func didSetDay(huntingDay: HuntingDay) {
        self.huntingDay = huntingDay
    }
    
    func setDay(huntingDay: HuntingDay) {
        didSetDay(huntingDay)
    }
}
