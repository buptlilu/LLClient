//
//  FavoriteResult.swift
//  LLMain
//
//  Created by lilu on 2022/4/7.
//

import Foundation

class FavoriteResult: Codable {
    /**
     *  该层收藏夹包含的自定义目录的数组，数组元素为收藏夹元数据
     */
    var sub_favorite:[String]?
    /**
     *  该层收藏夹包含的分区的数组，数组元素为分区元数据
     */
    var section: [Section]?
    /**
     *  该层收藏夹包含的版面的数组，数组元素为版面元数据
     */
    var board: [Board]?
}
