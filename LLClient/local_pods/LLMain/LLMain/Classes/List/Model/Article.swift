//
//  Article.swift
//  LLMain
//
//  Created by lilu on 2022/4/8.
//

import Foundation

/**
 "id": 518540,
 "group_id": 518540,
 "reply_id": 518540,
 "flag": "",
 "position": 0,
 "is_top": false,
 "is_subject": true,
 "has_attachment": false,
 "is_admin": false,
 "title": "建议改成：老八快乐屋",
 "user": {
     "id": "eriksench",
     "user_name": "eriksench",
     "face_url": "http://bbs.byr.cn/img/face_default_m.jpg",
     "face_width": 0,
     "face_height": 0,
     "gender": "m",
     "astro": "魔羯座",
     "life": 365,
     "qq": "1273033276",
     "msn": "",
     "home_page": "",
     "level": "用户",
     "is_online": true,
     "post_count": 210,
     "last_login_time": 1649408270,
     "last_login_ip": "61.148.245.*",
     "is_hide": false,
     "is_register": true,
     "score": 12187,
     "follow_num": 0,
     "fans_num": 0,
     "is_follow": false,
     "is_fan": false
 },
 "post_time": 1648374181,
 "board_name": "Food",
 "board_description": "秀色可餐",
 "reply_count": 1,
 "last_reply_user_id": "eriksench",
 "last_reply_time": 1648374181
 */

class Article: Codable {
    var id: Int?
    var group_id: Int?
    var reply_id: Int?
    var flag: String?
    var position: Int?
    var is_top: Bool?
    var is_subject: Bool?
    var has_attachment: Bool?
    var is_admin: Bool?
    var title: String?
    var user: User?
    var post_time: Int?
    var board_name: String?
    var board_description: String?
    var reply_count: Int?///该主题回复文章数    只存在于/board/:name，/threads/:board/:id和/search/threads中
    var last_reply_user_id: String?
    var last_reply_time: Int?
}
