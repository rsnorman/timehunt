//
//  ShadowView.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 11/21/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import UIKit

class ShadowView : UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setDarkness(0.4)
    }
    
    func setDarkness(_ darkness: CGFloat) {
        backgroundColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: darkness)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
}
