//
//  Api+List.swift
//  LLMain
//
//  Created by lilu on 2022/4/7.
//

import Foundation
import LLNetwork
import LLCommon

extension Api.List {
    class Response: HttpJsonResponse<SectionResult> {}
    class Request: HttpBaseRequest<Response>{
        override init() {
            super.init()
            url = Keys.BaseURL + "/section.json"
            requestType = .get
        }
    }
}
