//
//  AppDelegate.swift
//  LLClient
//
//  Created by lilu on 2022/3/31.
//

import UIKit
import LLMain

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let window = UIWindow.init()
        window.rootViewController = LoginViewController.init()
        window.backgroundColor = .white
        window.makeKeyAndVisible()
        self.window = window
        return true
    }
}

