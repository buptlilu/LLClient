//
//  HttpResponse.swift
//  LLNetwork
//
//  Created by lilu on 2022/4/1.
//

import Foundation
import LLCommon

open class HttpResponse: NSObject {
    public var httpResponseCode: Int = 0
    
    required public override init() {
        super.init()
    }
    
    open func parser(_ data: Data) {
        
    }
}

open class HttpMiddleResponse<DataType: Codable>: HttpResponse {
    public var data: DataType?
    open override func parser(_ resData: Data) {
        do {
            data = try JSONDecoder().decode(DataType.self, from:resData)
        } catch(let e) {
            Logger.error("JsonParserError: \(e)")
        }
    }
}
