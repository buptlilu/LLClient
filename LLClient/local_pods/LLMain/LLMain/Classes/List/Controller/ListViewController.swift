//
//  ListViewController.swift
//  LLMain
//
//  Created by lilu on 2022/4/2.
//

import Foundation
import LLCommon
import MJRefresh
import LLNetwork

class ListViewController: RootBaseController, UITableViewDelegate, UITableViewDataSource {
    
    var data: [Section]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(tableView)
        
        loadData()
    }
    
    func loadData() {
        let req = Api.List.Request()
        HttpClient.send(req: req) { success, res in
            if success {
                self.data = res.data?.section
                self.tableView.reloadData()
            }
            self.tableView.mj_header.endRefreshing()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init()
        let section = data?[indexPath.row]
        cell.textLabel?.text = section?.description
        return cell
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
