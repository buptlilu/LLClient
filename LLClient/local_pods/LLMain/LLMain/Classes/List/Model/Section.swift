//
//  Section.swift
//  LLMain
//
//  Created by lilu on 2022/4/7.
//

/*
 "name": "0",
 "description": "本站站务",
 "is_root": true,
 "parent": null
 
 name    string    分区名称
 description    string    分区表述
 is_root    boolean    是否是根分区
 parent    string    该分区所属根分区名称
 */


import Foundation

class Section: Codable {
    var name: String?
    var description: String?
    var is_root: Bool?
    var parent: String?
}
