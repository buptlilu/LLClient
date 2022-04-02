//
//  ListViewController.swift
//  LLMain
//
//  Created by lilu on 2022/4/2.
//

import Foundation

class ListViewController: RootBaseController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            let vc = BaseController.init()
            vc.view.backgroundColor = .red
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .orange
    }
}
