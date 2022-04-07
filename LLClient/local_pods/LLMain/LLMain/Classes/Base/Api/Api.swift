//
//  Api.swift
//  LLMain
//
//  Created by lilu on 2022/4/1.
//

import Foundation
import LLNetwork
import LLAccount

public class Api {
    public class login {}
    
    public class List {}
}

public class HttpBaseRequest<ResponseType: HttpResponse>: HttpRequest<ResponseType> {
    public override init() {
        super.init()
        if let user = AccountManager.shared.currentAccount() {
            params["oauth_token"] = user.access_token
        }
    }
}
