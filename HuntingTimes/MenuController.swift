//
//  MenuView.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 12/3/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import UIKit

class MenuController : UIViewController {
    override func viewDidLoad() {
        view.backgroundColor = .blackColor()
        view.alpha           = 0.0
    }
    
    override func viewDidAppear(animate: Bool) {
        UIView.animateWithDuration(0.4) {
            self.view.alpha = 0.9
        }
    }
}
