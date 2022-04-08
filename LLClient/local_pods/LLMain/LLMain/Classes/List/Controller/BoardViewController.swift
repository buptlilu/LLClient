//
//  BoardViewController.swift
//  LLMain
//
//  Created by lilu on 2022/4/7.
//

import Foundation
import LLCommon
import MJRefresh
import LLNetwork
 
class BoardViewController: NonBaseController, UITableViewDelegate, UITableViewDataSource, BoardCellDelegate {
    
    var handleLikeCell: BoardCell?
    var sectionName: String?
    var boards: [Board]? = []
    var sub_sections: [String]? = []
    var subSectionBoardResults: [BoardResult]? = []
    //收藏夹
    var favorites: [Board]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        if (boards?.count ?? 0) <= 0 {
            loadData()
        }
    }
    
    func loadData() {
        let group = DispatchGroup.init()
        group.enter()
        let collecReq = Api.Collect.Request()
        HttpClient.send(req: collecReq) { success, res in
            if success {
                self.favorites = res.data?.board
            }
            group.leave()
        }
        group.enter()
        let req = Api.List.Board.Request()
        req.url = req.url + "/\(sectionName ?? "").json"
        HttpClient.send(req: req) { success, res in
            if success {
                self.boards = res.data?.board
                self.sub_sections?.removeAll()
                if let subs = res.data?.sub_section, subs.count > 0 {
                    self.subSectionBoardResults?.removeAll()
                    self.sub_sections = subs
                    for sub in subs {
                        group.enter()
                        let subReq = Api.List.Board.Request()
                        subReq.url = subReq.url + "/\(sub).json"
                        HttpClient.send(req: subReq) { subSuccess, subRes in
                            if success, let subBoardRes = subRes.data {
                                self.subSectionBoardResults?.append(subBoardRes)
                            }
                            group.leave()
                        }
                    }
                }
            }
            
            group.leave()
        }
        
        group.notify(queue: .main) {[weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
            self.tableView.mj_header.endRefreshing()
        }
    }
    
    //MARK: tableView delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        if (subSectionBoardResults?.count ?? 0) > 0 {
            return 2
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (subSectionBoardResults?.count ?? 0) > 0 && section == 0 {
            return subSectionBoardResults?.count ?? 0
        }
        
        return boards?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = BoardCell.cellWithTableView(tableView)
        cell.likeBtn.isSelected = false
        if (subSectionBoardResults?.count ?? 0) > 0 && indexPath.section == 0 {
            cell.boardResult = subSectionBoardResults?[indexPath.row]
        } else {
            cell.board = boards?[indexPath.row]
            if let favorites = favorites {
                for likedBoard in favorites {
                    if likedBoard.name == cell.board?.name {
                        cell.likeBtn.isSelected = true
                        break
                    }
                }
            }
        }
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if (subSectionBoardResults?.count ?? 0) > 0 && indexPath.section == 0 {
            let boardResult = subSectionBoardResults?[indexPath.row]
            let sub_section = self.sub_sections?[indexPath.row]
            let vc = BoardViewController.init()
            vc.sectionName = sub_section
            vc.boards = boardResult?.board
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            
        }
    }
    
    //MARK: cell delegate
    func addOrDeleteFavorite(cell: BoardCell) {
        self.handleLikeCell = cell
        let titleStr = cell.likeBtn.isSelected ? "从收藏夹移除" : "加入收藏夹"
        let cancelStr = cell.likeBtn.isSelected ? "取消收藏" : "添加收藏"
        let sheet = UIAlertController.init(title: "将\(cell.board?.description ?? "")版面\(titleStr)?", message: nil, preferredStyle: .actionSheet)
        sheet.addAction(.init(title: cancelStr, style: .destructive, handler: { [weak self] action in
            guard let self = self else { return }
            let req = Api.Collect.Like.Request()
            req.handleType = cell.likeBtn.isSelected ? .unlike : .like
            req.params["name"] = self.handleLikeCell?.board?.name ?? ""
            HttpClient.send(req: req) { success, res in
                if success {
                    self.toast("\(cancelStr)成功")
                    cell.likeBtn.isSelected = !cell.likeBtn.isSelected
                } else {
                    self.toast("\(cancelStr)失败")
                }
            }
        }))
        sheet.addAction(.init(title: "取消", style: .cancel))
        self.present(sheet, animated: true)
    }
    
    lazy var tableView: UITableView = {
        let v = UITableView.init()
        v.separatorStyle = .none
        v.delegate = self
        v.dataSource = self
        v.mj_header = MJRefreshNormalHeader.init(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            self.loadData()
        })
        return v
    }()
}
