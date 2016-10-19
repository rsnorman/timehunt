//
//  Delay.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 11/22/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import Foundation

typealias dispatch_cancelable_closure = (_ cancel : Bool) -> ()

func delay(_ time:TimeInterval, closure:@escaping ()->()) ->  dispatch_cancelable_closure? {
    
    func dispatch_later(_ clsr:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(time * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: clsr)
    }
    
    var closure:()->()? = closure
    var cancelableClosure:dispatch_cancelable_closure?
    
    let delayedClosure:dispatch_cancelable_closure = { cancel in
        if let clsr = closure {
            if (cancel == false) {
                DispatchQueue.main.async(execute: clsr);
            }
        }
        closure = nil
        cancelableClosure = nil
    }
    
    cancelableClosure = delayedClosure
    
    dispatch_later {
        if let delayedClosure = cancelableClosure {
            delayedClosure(false)
        }
    }
    
    return cancelableClosure;
}
