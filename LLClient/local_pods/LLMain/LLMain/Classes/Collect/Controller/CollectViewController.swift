//
//  CollectViewController.swift
//  LLMain
//
//  Created by lilu on 2022/4/2.
//

import Foundation
import LLCommon
import MJRefresh
import LLNetwork

class CollectViewController: RootBaseController, UITableViewDelegate, UITableViewDataSource, BoardCellDelegate {
    var data: [Board]?
    var handleLikeCell: BoardCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(tableView)
        
        loadData()
    }
    
    func loadData() {
        let req = Api.Collect.Request()
        HttpClient.send(req: req) { success, res in
            if success {
                self.data = res.data?.board
                self.tableView.reloadData()
            }
            self.tableView.mj_header.endRefreshing()
        }
    }
    
    //MARK: tableView delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = BoardCell.cellWithTableView(tableView)
        let board = data?[indexPath.row]
        cell.board = board
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: board delegate
    func addOrDeleteFavorite(cell: BoardCell) {
        if cell.likeBtn.isSelected {
            self.handleLikeCell = cell
            let sheet = UIAlertController.init(title: "将\(cell.board?.description ?? "")版面从收藏夹移除?", message: "test", preferredStyle: .actionSheet)
            sheet.addAction(.init(title: "取消收藏", style: .destructive, handler: { [weak self] action in
                guard let self = self else { return }
                let req = Api.Collect.Delete.Request()
                req.params["name"] = self.handleLikeCell?.board?.name ?? ""
                HttpClient.send(req: req) { success, res in
                    if success {
                        self.toast("取消收藏成功")
                        self.data = res.data?.board
                        self.tableView.reloadData()
                    } else {
                        self.toast("取消收藏失败")
                    }
                }
            }))
            sheet.addAction(.init(title: "取消", style: .cancel))
            self.present(sheet, animated: true)
        }
    }
    
    lazy var tableView: UITableView = {
        let v = UITableView.init()
        v.separatorStyle = .none
        v.delegate = self
        v.dataSource = self
        v.frame = .init(x: 0, y: 0, width: Keys.kScreenWidth, height: Keys.kScreenHeight - Keys.kBottomBarHeight - Keys.kTopBarHeight)
        v.mj_header = MJRefreshNormalHeader.init(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            self.loadData()
        })
        return v
    }()
}
