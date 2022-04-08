//
//  CollectManager.swift
//  LLMain
//
//  Created by lilu on 2022/4/8.
//

import Foundation
import LLNetwork
import LLCommon

class CollectManager: BaseManager {
    private var data: [Board]?
    
    public func loadCollectData(completeBlock: (([Board]?) ->Void)? = nil) {
        let req = Api.Collect.Request()
        HttpClient.send(req: req) { success, res in
            self.data = res.data?.board
            completeBlock?(self.data)
        }
    }
    
    public func updateCollectData(newData: [Board]?) {
        data = newData
    }
    
    public func collectData() -> [Board]? {
        return data
    }
    
    public func collectHandle(rootVc: UIViewController, handleType: Api.Collect.Like.HandleType, board: Board?, completeBlock:((Bool) -> Void)? = nil) {
        let titleStr = handleType == .unlike ? "从收藏夹移除" : "加入收藏夹"
        let cancelStr = handleType == .unlike ? "取消收藏" : "添加收藏"
        let sheet = UIAlertController.init(title: "将\(board?.description ?? "")版面\(titleStr)?", message: nil, preferredStyle: .actionSheet)
        sheet.addAction(.init(title: cancelStr, style: .destructive, handler: { [weak self] action in
            guard let self = self else { return }
            let req = Api.Collect.Like.Request()
            req.handleType = handleType
            req.params["name"] = board?.name ?? ""
            HttpClient.send(req: req) { success, res in
                if success {
                    self.toast("\(cancelStr)成功")
                    self.data = res.data?.board
                } else {
                    self.toast("\(cancelStr)失败")
                }
                completeBlock?(success)
            }
        }))
        sheet.addAction(.init(title: "取消", style: .cancel))
        rootVc.present(sheet, animated: true)
    }
    
    override func filePath() -> URL? {
        var path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        path?.appendPathComponent("collects")
        Logger.info("collect path:\(path?.path)")
        return path
    }
}
