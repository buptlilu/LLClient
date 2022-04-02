//
//  Account.swift
//  LLAccount
//
//  Created by lilu on 2022/4/1.
//

import Foundation

public class Account: NSObject, Codable {
    var username: String = ""
    var access_token: String = ""
    var expires_date: Double = 0
    
    public init(_ token: String?, _ expires_in: Int?, _ name: String?) {
        super.init()
        access_token = token ?? ""
        username = name ?? ""
        expires_date = Double(expires_in ?? 0) + Date.init().timeIntervalSince1970
    }
    
    public func isTokenValid() -> Bool {
        if username.count <= 0 {
            return false
        }
        
        if access_token.count <= 0 {
            return false
        }
        
        if Date.init().timeIntervalSince1970 - expires_date > 0 {
            return false
        }
        
        return true
    }
}
