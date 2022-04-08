//
//  Pagination.swift
//  LLMain
//
//  Created by lilu on 2022/4/8.
//

/*
 "pagination": {
         "page_all_count": 232,
         "page_current_count": 2,
         "item_page_count": 30,
         "item_all_count": 6944
     },
 */

import Foundation

class Pagination: Codable {
    var page_all_count: Int?
    var page_current_count: Int?
    var item_page_count: Int?
    var item_all_count: Int?
}
