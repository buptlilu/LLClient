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
    
    public func saveAllAccounts() {
        DispatchQueue.global().async {
            if let path = self.accountFilePath()  {
                var models = [Account].init()
                for account in self.accounts {
                    if account.value.isTokenValid() {
                        models.append(account.value)
                    }
                }
                do {
                    let datasToWrite = try JSONEncoder().encode(models)
                    try datasToWrite.write(to: path)
                    self.loadAccounts()
                } catch {
                    Logger.error("fail to save accounts error:\(error)")
                }
            }
        }
    }
    
    public func saveAccount(_ account: Account) {
        if !account.isTokenValid() {
            return
        }
        
        accounts[account.username] = account
        saveAllAccounts()
    }
    
    public func loadAccounts() {
        if let path = self.accountFilePath()  {
            do {
                if FileManager.default.fileExists(atPath: path.path) {
                    let datas = try Data.init(contentsOf: path)
                    let models = try JSONDecoder().decode([Account].self, from: datas)
                    self.accounts.removeAll()
                    for model in models {
                        if model.isTokenValid() {
                            self.accounts[model.username] = model
                        }
                    }
                    self.logAccounts()
                } else {
                    Logger.info("account path not exist:\(path.path)")
                }
            } catch {
                Logger.error("fail to load accounts error:\(error)")
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
