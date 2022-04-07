//
//  BoardResult.swift
//  LLMain
//
//  Created by lilu on 2022/4/7.
//

import Foundation

class BoardResult: Codable {
    var name: String?
    var description: String?
    var is_root: Bool?
    var parent: String?
    var sub_section:[String]?
    var board:[Board]?
}
