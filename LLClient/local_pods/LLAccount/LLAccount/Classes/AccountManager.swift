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
    
    public func topAccount() -> Account?{
        if accounts.count > 0 {
            return accounts.first?.value
        }
        
        return nil
    }
    
    public func saveAccount(_ account: Account) {
        if !account.isTokenValid() {
            return
        }
        
        accounts[account.username] = account
        
        var models = [Account].init()
        for account in accounts {
            if account.value.isTokenValid() {
                models.append(account.value)
            }
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
                Logger.info("第\(index)个账号:username:\(model.key)  access_token:\(model.value.access_token)")
            }
        }
    }
}
