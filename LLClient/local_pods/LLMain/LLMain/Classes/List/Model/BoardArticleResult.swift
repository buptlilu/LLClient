//
//  BoardArticleResult.swift
//  LLMain
//
//  Created by lilu on 2022/4/8.
//

import Foundation

class BoardArticleResult: Codable {
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
    
    var pagination: Pagination?
    var article:[Article]?
    
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
        case pagination
        case article
    }
}
