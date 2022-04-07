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
}
