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
    var boards: [Board]? = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadCacheData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(tableView)
    }
    
    func loadCacheData() {
        if let collectData = CollectManager.shared.collectData(), collectData.count > 0 {
            boards = collectData
            tableView.reloadData()
        } else {
            loadData()
        }
    }
    
    func loadData() {
        CollectManager.shared.loadCollectData { newData in
            self.boards = newData
            self.tableView.reloadData()
            self.tableView.mj_header.endRefreshing()
        }
    }
    
    //MARK: tableView delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return boards?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = BoardCell.cellWithTableView(tableView)
        let board = boards?[indexPath.row]
        cell.board = board
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = BoardArticleViewController.init()
        let board = boards?[indexPath.row]
        vc.boardName = board?.name ?? ""
        vc.navigationItem.title = board?.description
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: board delegate
    func addOrDeleteFavorite(cell: BoardCell) {
        if cell.likeBtn.isSelected {
            CollectManager.shared.collectHandle(rootVc: self, handleType: .unlike, board: cell.board) { [weak self] success in
                guard let self = self else { return }
                if success {
                    self.loadCacheData()
                }
            }
        }
    }
    
    lazy var tableView: UITableView = {
        let v = UITableView.init()
        v.separatorStyle = .none
        v.delegate = self
        v.dataSource = self
        v.frame = .init(x: 0, y: 0, width: Keys.kScreenWidth, height: Keys.kScreenHeight - Keys.kTopBarHeight)
        v.mj_header = MJRefreshNormalHeader.init(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            self.loadData()
        })
        return v
    }()
}
