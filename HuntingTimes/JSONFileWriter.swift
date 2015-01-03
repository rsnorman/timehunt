//
//  JSONFileWriter.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 12/25/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import UIKit

class JSONFileWriter {
    class func write(jsonData: [String : AnyObject], fileName: String) {
        if let data = NSJSONSerialization.dataWithJSONObject(jsonData, options: NSJSONWritingOptions.PrettyPrinted, error: nil) {
            let documentsDir = getFolder()!
            let filePath = documentsDir.stringByAppendingPathComponent(fileName)
            data.writeToFile(filePath, atomically: true)
        }
    }
    
    class func read(fileName: String) -> [String : AnyObject]? {
        let documentsDir = getFolder()!
        let filePath = documentsDir.stringByAppendingPathComponent(fileName)
        if let jsonFile = NSInputStream(fileAtPath: filePath) {
            var error = NSErrorPointer.null()
            jsonFile.open()
            if let jsonDict: AnyObject = NSJSONSerialization.JSONObjectWithStream(jsonFile, options: NSJSONReadingOptions.allZeros, error: error) {
                return jsonDict as? [String : AnyObject]
            }
            jsonFile.close()
        }
        
        return nil
    }
    
    private
    
    class func getFolder() -> String? {
        let nsDocumentDirectory = NSSearchPathDirectory.DocumentDirectory
        let nsUserDomainMask = NSSearchPathDomainMask.UserDomainMask
        if let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true) {
            if paths.count > 0 {
                if let dirPath = paths[0] as? String {
                    return dirPath
                }
            }
        }
        return nil
    }
}
