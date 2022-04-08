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
    
    public class Board{}
    public class BoardArticle{}
}

extension Api.List.Board {
    class Response: HttpJsonResponse<BoardResult> {}
    class Request: HttpBaseRequest<Response>{
        override init() {
            super.init()
            url = Keys.BaseURL + "/section"
            requestType = .get
        }
    }
}

extension Api.List.BoardArticle {
    class Response: HttpJsonResponse<BoardArticleResult> {}
    class Request: HttpBaseRequest<Response>{
        override init() {
            super.init()
            url = Keys.BaseURL + "/board"
            requestType = .get
            params["mode"] = 2
            params["count"] = 30
        }
    }
}
