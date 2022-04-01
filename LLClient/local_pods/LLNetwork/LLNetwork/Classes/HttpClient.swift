//
//  HttpClient.swift
//  LLNetwork
//
//  Created by lilu on 2022/4/1.
//

import Foundation
import Alamofire

public class HttpClient: NSObject {
    public class func get(url: String, params: [String: Any]?, completeBlock: ((Bool,Data?) -> Void)? = nil) {
        AF.request(url, method: .get, parameters: params).responseData { res in
            if res.response?.statusCode == 200 && res.data != nil {
                completeBlock?(true, res.data)
            } else {
                completeBlock?(false, res.data)
            }
        }
    }
    
    public class func post(url: String, params: [String: Any]?, completeBlock: ((Bool,Data?) -> Void)? = nil) {
        AF.request(url, method: .post, parameters: params).responseData { res in
            if res.response?.statusCode == 200 && res.data != nil {
                completeBlock?(true, res.data)
            } else {
                completeBlock?(false, res.data)
            }
        }
    }
}
