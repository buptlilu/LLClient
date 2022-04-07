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
 
 
 "name": "AimBUPT",
 "manager": "shuizai lw2171 DaveSun zhc0614",
 "description": "北邮欢迎你",
 "class": "[专区]",
 "section": "1",
 "is_favorite": false,
 "threads_today_count": 1,
 "allow_attachment": true,
 "post_today_count": 8,
 "post_threads_count": 216,
 "post_all_count": 1195,
 "user_online_count": 17,
 "is_read_only": false,
 "is_no_reply": false,
 "allow_anonymous": false,
 "allow_outgo": false,
 "allow_post": true
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
    
    var post_today_count: Int?
    var post_threads_count: Int?
    var post_all_count: Int?
    var user_online_count: Int?
    
    var is_read_only: Bool?
    var is_no_reply: Bool?
    var allow_anonymous: Bool?
    var allow_outgo: Bool?
    var allow_post: Bool?
    
    enum CodingKeys : String, CodingKey {
        case name
        case manager
        case description
        case llclass = "class"
        case section
        case is_favorite
        case threads_today_count
        case allow_attachment
        case post_today_count
        case post_threads_count
        case post_all_count
        case user_online_count
        case is_read_only
        case is_no_reply
        case allow_anonymous
        case allow_outgo
        case allow_post
    }
}
