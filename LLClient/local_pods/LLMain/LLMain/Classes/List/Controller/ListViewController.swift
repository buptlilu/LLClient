//
//  ListViewController.swift
//  LLMain
//
//  Created by lilu on 2022/4/2.
//

import Foundation

class ListViewController: RootBaseController, UITableViewDelegate, UITableViewDataSource {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell.init()
    }
    
    lazy var tableView: UITableView = {
        let v = UITableView.init()
        v.separatorStyle = .none
        v.delegate = self
        v.dataSource = self
        return v
    }()
}
