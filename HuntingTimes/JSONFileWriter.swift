//
//  JSONFileWriter.swift
//  HuntingTimes
//
//  Created by Ryan Norman on 12/25/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import UIKit

class JSONFileWriter {
    // TODO: Capture errors
    class func write(_ jsonData: [String : AnyObject], fileName: String) {
        let data = try! JSONSerialization.data(withJSONObject: jsonData, options: JSONSerialization.WritingOptions.prettyPrinted)
        let documentsDir = getFolder()!
        guard let fileurl = NSURL(fileURLWithPath: documentsDir).appendingPathComponent(fileName) else {
            //print error
            return
        }
        
        if FileManager.default.fileExists(atPath: fileurl.path) {
            
            let fileHandle = try! FileHandle(forWritingTo: fileurl)
            fileHandle.seekToEndOfFile()
            fileHandle.write(data)
            fileHandle.closeFile()
        } else {
            // TODO: print error
        }
    }
    
    // TODO: Capture errors
    class func read(_ fileName: String) -> [String : AnyObject]? {
        let documentsDir = getFolder()!
        guard let fileurl = NSURL(fileURLWithPath: documentsDir).appendingPathComponent(fileName) else {
            // TODO: print error
            return nil
        }
        guard let jsonFile = InputStream(url: fileurl) else {
            return nil
        }

        jsonFile.open()
        let jsonDict = try! JSONSerialization.jsonObject(with: jsonFile)
        jsonFile.close()
        
        return jsonDict as? [String : AnyObject]
    }
    
    fileprivate
    
    class func getFolder() -> String? {
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        guard let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true) as? [String] else {
            return nil
        }

        if paths.count > 0 {
            if let dirPath = paths[0] as? String {
                return dirPath
            }
        }
        return nil
    }
}
