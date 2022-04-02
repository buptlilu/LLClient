//
//  ControllerManager.swift
//  LLMain
//
//  Created by lilu on 2022/4/2.
//

import Foundation
import LLAccount
import LLCommon
import CoreData
import UIKit

public class ControllerManager : NSObject {
    public func rootViewController() -> UIViewController? {
        if let user = AccountManager.shared.currentAccount() {
            Logger.info("已登录 当前账号:\(user.username)")
            return createTabbarVc()
        }
        
        Logger.info("未登录 进入登录界面")
        return LoginViewController.init()
    }
    
    private func createTabbarVc() -> UIViewController? {
        let listVc = YDNavigationController.init(rootViewController: ListViewController.init())
        let hotVc = YDNavigationController.init(rootViewController: HotViewController.init())
        let collectVc = YDNavigationController.init(rootViewController: CollectViewController.init())
        let meVc = YDNavigationController.init(rootViewController: MeViewController.init())
        
        let tabbarVc = RDVTabBarController.init()
        tabbarVc.tabBar.setHeight(Keys.kBottomBarHeight)
        tabbarVc.viewControllers = [listVc, hotVc, collectVc, meVc]
        
        let imageNames = ["list", "hot", "collect", "me"]
        let titles = ["版面", "热点", "收藏", "我的"]
        
        var index = 0
        for item in tabbarVc.tabBar.items {
            if let tabBarItem = item as? RDVTabBarItem{
                if index >= titles.count || index >= imageNames.count {
                    break
                }
                if let imageNormal = UIImage.init(named: "\(imageNames[index])_normal"),let imageSelected = UIImage.init(named: "\(imageNames[index])_selected")  {
                    tabBarItem.setFinishedSelectedImage(imageSelected, withFinishedUnselectedImage: imageNormal)
                
                }
                tabBarItem.title = titles[index]
                tabBarItem.badgeBackgroundColor = .red
                tabBarItem.badgeTextColor = .white
                tabBarItem.badgeTextFont = .systemFont(ofSize: 9)
                tabBarItem.badgePositionAdjustment = .init(horizontal: -12, vertical: 1)
                tabBarItem.selectedTitleAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11), NSAttributedString.Key.foregroundColor: UIColor.theme]
                tabBarItem.unselectedTitleAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11), NSAttributedString.Key.foregroundColor: UIColor.init(hex: 0x999999)]
                tabBarItem.titlePositionAdjustment = .init(horizontal: 0, vertical: -5)
                tabBarItem.imagePositionAdjustment = .init(horizontal: 0, vertical: 3)
                index += 1
            }
        }
        tabbarVc.tabBar.backgroundColor = .white
        tabbarVc.tabBar.backgroundView.backgroundColor = .white
        let spaceView = UIView.spaceView()
        tabbarVc.tabBar.backgroundView.addSubview(spaceView)
        spaceView.snp.makeConstraints { make in
            make.height.equalTo(0.5)
            make.left.right.top.equalToSuperview()
        }
        return tabbarVc
    }
    
    public static var shared = ControllerManager.init()
}
