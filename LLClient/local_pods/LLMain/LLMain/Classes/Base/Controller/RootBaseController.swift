//
//  RootBaseController.swift
//  LLMain
//
//  Created by lilu on 2022/4/2.
//

import Foundation

class RootBaseController: UIViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.rdv_tabBarController?.setTabBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let ti = self.rdv_tabBarItem
        self.navigationItem.title = self.rdv_tabBarItem?.title ?? ""
    }
}
