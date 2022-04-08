//
//  AccountManager.swift
//  LLAccount
//
//  Created by lilu on 2022/4/1.
//

import Foundation
import LLCommon

public class AccountManager: NSObject {
    public static var shared = AccountManager()
    
    private var accounts: [String: Account] = [:]
    private var currentUser: Account? = nil
    
    public func allAccounts() -> [String: Account]{
        return accounts
    }
    
    public func currentAccount() -> Account?{
        if let user = currentUser {
            if !user.isTokenValid() {
                self.toast("当前用户token过期，请切换用户货重新登录")
            }
            
            return user
        }
        
        return nil
    }
    
    public func saveAccount(_ account: Account) {
        if !account.isTokenValid() {
            return
        }
        
        //只允许当前一个账号处于登录状态
        for item in accounts {
            item.value.login = false
        }
        
        accounts[account.username] = account
        
        var models = [Account].init()
        for account in accounts {
            if account.value.isTokenValid() {
                models.append(account.value)
            }
        }
        
        //新登录的账号总在最前面
        models.sorted { a, b in
            return a.expires_date > b.expires_date
        }
        CacheManager.shared.save(filePath: self.filePath(), models: models)
        
        selectCurrentUser()
    }
    
    public func loadAccounts() {
        CacheManager.shared.loadSync(filePath: self.filePath(), modelType: [Account].self) { success, models in
            if success, let models = models {
                self.accounts.removeAll()
                for model in models {
                    if model.isTokenValid() {
                        self.accounts[model.username] = model
                    }
                }
                self.selectCurrentUser()
                self.logAccounts()
            }
        }
    }
    
    private func selectCurrentUser() {
        if accounts.count > 0 {
            var validUsers = [Account]()
            for item in accounts {
                if item.value.isTokenValid() {
                    validUsers.append(item.value)
                }
            }
            
            for user in validUsers {
                if user.login {
                    currentUser = user
                    return
                }
            }
            
            currentUser = validUsers.first
        }
    }

    private func filePath() -> URL? {
        //file:///var/mobile/Containers/Data/Application/DFD879D7-31D4-40E2-A224-6D3ADAAB2A1E/Documents/accounts
        var path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        path?.appendPathComponent("accounts")
        Logger.info("account path:\(path?.path)")
        return path
    }
    
    private func logAccounts() {
        Logger.info("共登录了\(accounts.count)个账号")
        if accounts.count > 0 {
            var index = 0
            for model in accounts {
                index = index + 1
                Logger.info("第\(index)个账号:username:\(model.key)  access_token:\(model.value.access_token)  登录状态:\(model.value.login)")
            }
        }
    }
}
