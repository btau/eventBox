//
//  Debug.swift
//
//  Created by BergerBytes on 2/18/16.
//  Copyright © 2016 Michael Berger All rights reserved.
//

import Foundation

struct Debug {
    static func log(message: String, file: String = __FILE__, function: String = __FUNCTION__, line: Int = __LINE__, column: Int = __COLUMN__)  {
        print("Log: \"\(message)\"  ->  File: \(NSURL(string: file)!.lastPathComponent!)  Function: \(function)  LINE: \(line)")
    }
}
