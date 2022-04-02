//
//  AccountManager.swift
//  LLAccount
//
//  Created by lilu on 2022/4/1.
//

import Foundation
import LLCommon

public class AccountManager: NSObject {
    public static var shared = AccountManager.init()
    
    var accounts: [String: Account] = [:]
    
    public override init() {
        super.init()
    }
    
    public func allAccounts() -> [String: Account]{
        return accounts
    }
    
    public func currentAccount() -> Account?{
        if accounts.count > 0 {
            for item in accounts {
                if item.value.login {
                    return item.value
                }
            }
            
            return accounts.first?.value
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
        Cache.shared.save(filePath: self.accountFilePath(), models: models)
    }
    
    public func loadAccounts() {
        Cache.shared.load(filePath: self.accountFilePath(), modelType: [Account].self) { success, models in
            if success, let models = models {
                self.accounts.removeAll()
                for model in models {
                    if model.isTokenValid() {
                        self.accounts[model.username] = model
                    }
                }
                self.logAccounts()
            }
        }
    }
    
    private func accountFilePath() -> URL? {
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
