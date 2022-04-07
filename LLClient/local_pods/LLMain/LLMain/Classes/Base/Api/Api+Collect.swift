//
//  Api+Collect.swift
//  LLMain
//
//  Created by lilu on 2022/4/7.
//

import Foundation
import LLNetwork
import LLCommon

extension Api.Collect {
    class Response: HttpJsonResponse<FavoriteResult> {}
    class Request: HttpBaseRequest<Response>{
        override init() {
            super.init()
            url = Keys.BaseURL + "/favorite/0.json"
            requestType = .get
        }
    }
    
    public class Delete{}
    public class Add{}
}

extension Api.Collect.Delete {
    class Response: HttpJsonResponse<FavoriteResult> {}
    class Request: HttpBaseRequest<Response>{
        override init() {
            super.init()
            url = Keys.BaseURL + "/favorite/delete/0.json"
            params["dir"] = "0"
            params["level"] = "0"
            requestType = .post
        }
    }
}

extension Api.Collect.Add {
    class Response: HttpJsonResponse<FavoriteResult> {}
    class Request: HttpBaseRequest<Response>{
        override init() {
            super.init()
            url = Keys.BaseURL + "/favorite/add/0.json"
            params["dir"] = "0"
            params["level"] = "0"
            requestType = .post
        }
    }
}
