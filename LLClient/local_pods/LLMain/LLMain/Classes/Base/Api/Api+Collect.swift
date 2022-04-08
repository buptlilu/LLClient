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
    
    public class Like{}
}

extension Api.Collect.Like {
    enum HandleType: String {
        case like = "like"
        case unlike = "unlike"
    }
    
    class Response: HttpJsonResponse<FavoriteResult> {}
    class Request: HttpBaseRequest<Response>{
        override init() {
            super.init()
            url = Keys.BaseURL + "/favorite/delete/0.json"
            params["dir"] = "0"
            params["level"] = "0"
            requestType = .post
        }
        
        var handleType: HandleType = .unlike {
            didSet {
                if handleType == .like {
                    url = Keys.BaseURL + "/favorite/add/0.json"
                } else {
                    url = Keys.BaseURL + "/favorite/delete/0.json"
                }
            }
        }
    }
}
