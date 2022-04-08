//
//  BaseManager.swift
//  LLCommon
//
//  Created by lilu on 2022/4/8.
//

import Foundation

open class BaseManager: NSObject {
    public required override init() {
        super.init()
    }
    
    public static func shared() -> Self {
        return Self()
    }
    
    open func filePath() -> URL? {
        return nil
    }
}
