//
//  LLKeys.swift
//  LLCommon
//
//  Created by lilu on 2022/3/31.
//

import Foundation

public class LLKeys: NSObject {
    //URL网络相关
    let LLBaseURL          = "https://bbs.byr.cn/open"
    let LLAuthorizeBaseUrl = "http:bbs.byr.cn/oauth2/authorize"
    let LLClient_id        = "dcaea32813eca7e0a547728b73ab060a"
    let LLRedirect_uri     = "http://bbs.byr.cn/oauth2/callback"
    let LLResponse_type    = "code"
    let LLState            = "35f7879b051b0bcb77a015977f5aeeeb"
    let LLAppleid          = "xuyang2324@hotmail.com"
    let LLBundleid         = "lilu.byriOSClientByLilu"
    let LLClient_secret    = "ce9bf0c1796adf3f3136a5eb0c54c059"
    let LLGrant_type       = "authorization_code"
    
    static var shared = LLKeys()
}
