//
//  TestMode.swift
//  LLCommon
//
//  Created by lilu on 2022/4/1.
//

import Foundation

public class TestMode: NSObject {
    private var testMode = false
    
    public var isTestMode: Bool {
        return testMode
    }
    
    public func turnOn() {
        testMode = true
    }
    
    public func turnOff() {
        testMode = false
    }
    
    public static var shared = TestMode()
}
