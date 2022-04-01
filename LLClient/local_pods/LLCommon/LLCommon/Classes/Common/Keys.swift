//
//  Keys.swift
//  LLCommon
//
//  Created by lilu on 2022/3/31.
//

import Foundation

public class Keys: NSObject {
    //URL网络相关
    public let BaseURL          = "https://bbs.byr.cn/open"
    public let AuthorizeBaseUrl = "https:bbs.byr.cn/oauth2/authorize"
    public let OAuthURL         = "https://bbs.byr.cn/oauth2/official"
    public let Client_id        = "dcaea32813eca7e0a547728b73ab060a"
    public let Redirect_uri     = "http://bbs.byr.cn/oauth2/callback"
    public let Response_type    = "code"
    public let State            = "35f7879b051b0bcb77a015977f5aeeeb"
    public let Appleid          = "xuyang2324@hotmail.com"
    public let Bundleid         = "lilu.byriOSClientByLilu"
    public let Client_secret    = "ce9bf0c1796adf3f3136a5eb0c54c059"
    public let Grant_type       = "authorization_code"
    
    public static var shared = Keys()
}
