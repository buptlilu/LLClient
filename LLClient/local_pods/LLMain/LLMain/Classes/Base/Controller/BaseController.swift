//
//  BaseController.swift
//  LLMain
//
//  Created by lilu on 2022/4/2.
//

import Foundation

class BaseController: UIViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.rdv_tabBarController?.setTabBarHidden(true, animated: true)
    }
}


