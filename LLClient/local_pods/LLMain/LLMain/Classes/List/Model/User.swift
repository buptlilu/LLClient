//
//  User.swift
//  LLMain
//
//  Created by lilu on 2022/4/8.
//

import Foundation

/**
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
 */

class User: Codable {
    var id: String? ///用户id
    var user_name: String?
    var face_url: String?
    var face_width: Int?
    var face_height: Int?
    var gender: String?
    var astro: String?///星座
    var life: Int?///用户生命值
    var qq: String?
    var msn: String?
    var home_page: String?
    var level: String?
    var is_online: Bool?
    var post_count: Int?///用户发文数量
    var last_login_time: Int? ///用户上次登录时间，unixtimestamp
    var last_login_ip: String?
    var is_hide: Bool?///用户是否隐藏性别和星座
    var is_register: Bool?
    var score: Int?
    var follow_num: Int?
    var fans_num: Int?
    var is_follow: Bool?
    var is_fan: Bool?
}
