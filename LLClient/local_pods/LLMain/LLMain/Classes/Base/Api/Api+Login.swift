//
//  Api+Login.swift
//  LLMain
//
//  Created by lilu on 2022/4/1.
//

import Foundation
import LLNetwork
import LLCommon

extension Api.Login {
    class Response: HttpJsonResponse<LoginResult> {}
    class Request: HttpRequest<Response>{
        override init() {
            super.init()
            url = Keys.OAuthURL
            requestType = .post
            params["appkey"] = "8b0d6c0b2ff8ef15c35c896435f0f337"
            params["response_type"] = Keys.Response_type
            params["redirect_uri"] = Keys.Redirect_uri
            params["state"] = Keys.State
            params["scope"] = "/"
            params["source"] = "1503026743-1"
        }
    }
}
