//
//  LoginResult.swift
//  LLMain
//
//  Created by lilu on 2022/4/1.
//

import Foundation

class LoginResult: Codable {
    var access_token: String?
    var expires_in: Int?
    var code: Int?
    var msg: String?
}
