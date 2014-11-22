//
//  HuntingTimeParser.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 11/22/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import Foundation

class HuntingTimeParser {
    class func parse() -> [[String:String]] {
        let path = NSBundle.mainBundle().pathForResource("hunting-times", ofType: "csv")
        
        println(path)
        
        return [
            [
                "start" : "2014 Nov 22 7:02 AM",
                "stop"  : "2014 Nov 22 5:35 PM"
            ], [
                "start" : "2014 Nov 23 7:03 AM",
                "stop"  : "2014 Nov 23 5:34 PM"
            ], [
                "start" : "2014 Nov 24 7:04 AM",
                "stop"  : "2014 Nov 24 5:34 PM"
            ], [
                "start" : "2014 Nov 25 7:05 AM",
                "stop"  : "2014 Nov 25 5:33 PM"
            ], [
                "start" : "2014 Nov 26 7:06 AM",
                "stop"  : "2014 Nov 26 5:33 PM"
            ], [
                "start" : "2014 Nov 27 7:08 AM",
                "stop"  : "2014 Nov 27 5:32 PM"
            ], [
                "start" : "2014 Nov 28 7:09 AM",
                "stop"  : "2014 Nov 28 5:32 PM"
            ], [
                "start" : "2014 Nov 29 7:10 AM",
                "stop"  : "2014 Nov 29 5:31 PM"
            ], [
                "start" : "2014 Nov 30 7:11 AM",
                "stop"  : "2014 Nov 30 5:31 PM"
            ], [
                "start" : "2014 Dec 1 7:12 AM",
                "stop"  : "2014 Dec 1 5:31 PM"
            ]
        ]
    }
}
