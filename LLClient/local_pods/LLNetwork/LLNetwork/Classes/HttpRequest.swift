//
//  HttpRequest.swift
//  LLNetwork
//
//  Created by lilu on 2022/4/1.
//

import Foundation
import Alamofire
import SwiftyJSON

public enum HttpRequestMethod: String {
    case post = "post"
    case get = "get"
    case delete = "delete"
    
    func httpMethod() -> HTTPMethod {
        switch self {
        case .post:
            return .post
        case .get:
            return .get
        case .delete:
            return .delete
        }
    }
}

open class HttpRequest<ResponseType: HttpResponse>: NSObject {
    public var params: [String : Any] = [:]
    public var requestType: HttpRequestMethod = .get
    public var url: String = ""
    
    public func initResponse() -> ResponseType {
        return ResponseType.init()
    }
}
