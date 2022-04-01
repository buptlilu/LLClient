//
//  HttpClient.swift
//  LLNetwork
//
//  Created by lilu on 2022/4/1.
//

import Foundation
import Alamofire

public class HttpClient: NSObject {
    public class func send<ResponseType: HttpResponse>(req: HttpRequest<ResponseType>, completeBlock: ((Bool, ResponseType)->Void)?) {
        AF.request(req.url, method: req.requestType.httpMethod(), parameters: req.params).responseData { afRes in
            let res = req.initResponse()
            res.httpResponseCode = afRes.response?.statusCode ?? 0
            if afRes.response?.statusCode == 200 && afRes.data != nil {
                res.parser(afRes.data!)
                completeBlock?(true, res)
            } else {
                completeBlock?(true, res)
            }
        }
    }
}
