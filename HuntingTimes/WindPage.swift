//
//  WindPage.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 11/4/17.
//  Copyright © 2017 Ryan Norman. All rights reserved.
//

import Foundation
import UIKit

class WindPage : HuntingPageView {
    required init(frame: CGRect) {
        super.init(frame: frame, huntingColumnsClass: WindColumns.self)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
