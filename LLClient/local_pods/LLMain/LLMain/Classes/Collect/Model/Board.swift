//
//  Board.swift
//  LLMain
//
//  Created by lilu on 2022/4/7.
//

/**
 
 "name": "BBSOpenAPI",
 "manager": "paper777",
 "description": "北邮人开放平台",
 "class": "[API ]",
 "section": "2",
 "is_favorite": true,
 "threads_today_count": 0,
 "allow_attachment": true
 */

import Foundation

class Board: Codable {
    var name: String?
    var manager: String?
    var description: String?
    var llclass: String?
    var section: String?
    var is_favorite: Bool?
    var threads_today_count: Int?
    var allow_attachment: Bool?
    
    enum CodingKeys : String, CodingKey {
        case name
        case manager
        case description
        case llclass = "class"
        case section
        case is_favorite
        case threads_today_count
        case allow_attachment
    }
}
