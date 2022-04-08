//
//  BoardArticleViewController.swift
//  LLMain
//
//  Created by lilu on 2022/4/8.
//

import Foundation
import LLCommon
import MJRefresh
import LLNetwork

class BoardArticleViewController: NonBaseController, UITableViewDelegate, UITableViewDataSource {
    var page = 1
    var boardName = ""
    var data: BoardArticleResult?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        loadData()
    }
    
    func loadData() {
        let req = Api.List.BoardArticle.Request()
        req.url = req.url + "/\(boardName ?? "").json"
        HttpClient.send(req: req) { success, res in
            if success {
                self.data = res.data
                self.tableView.reloadData()
            }
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
        }
    }
    
    //MARK: tableView delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell.init()
    }
    
    
    lazy var tableView: UITableView = {
        let v = UITableView.init()
        v.separatorStyle = .none
        v.delegate = self
        v.dataSource = self
        v.mj_header = MJRefreshNormalHeader.init(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            self.page = 1
            self.loadData()
        })
        v.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            self.page += 1
            self.loadData()
        })
        return v
    }()
}
