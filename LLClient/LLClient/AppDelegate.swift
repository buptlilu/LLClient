//
//  AppDelegate.swift
//  LLClient
//
//  Created by lilu on 2022/3/31.
//

import UIKit
import LLMain
import LLCommon
import LLAccount

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Logger.register()
        AccountManager.shared().loadAccounts()
        let window = UIWindow.init()
        window.rootViewController = ControllerManager.shared().rootViewController()
        window.backgroundColor = .white
        window.makeKeyAndVisible()
        self.window = window
        return true
    }
}

