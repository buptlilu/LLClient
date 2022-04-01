//
//  Api+Login.swift
//  LLMain
//
//  Created by lilu on 2022/4/1.
//

import Foundation
import LLNetwork
import LLCommon

extension Api.login {
    class Response: HttpMiddleResponse<LoginResult> {}
    class Request: HttpRequest<Response>{
        override init() {
            super.init()
            url = Keys.shared.OAuthURL
            params["appkey"] = "8b0d6c0b2ff8ef15c35c896435f0f337"
            params["response_type"] = Keys.shared.Response_type
            params["redirect_uri"] = Keys.shared.Redirect_uri
            params["state"] = Keys.shared.State
            params["scope"] = "/"
            params["source"] = "1503026743-1"
        }
    }
}
