//
//  GlobalVariable.swift
//  MartianNewsReader
//
//  Created by Xin Zou on 2/2/19.
//  Copyright © 2019 NYTimes. All rights reserved.
//

import Foundation


//MARK: - Helper Methods

func debugLog(_ message: String,
              function: String = #function,
              file: String = #file,
              line: Int = #line) {
    DLog("Message \"\(message)\" (File: \(file), Function: \(function), Line: \(line))")
}

func DLog(_ message: String) {
    #if DEBUG
    print(message)
    #endif
}

func L(_ key: String) -> String {
    return NSLocalizedString(key, comment: "")
}
