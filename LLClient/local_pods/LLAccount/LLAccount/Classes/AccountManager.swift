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
    
    var accounts: [Account] = []
    
    public override init() {
        super.init()
        loadAccounts()
    }
    
    public func allAccounts() -> [Account]{
        return accounts
    }
    
    public func topAccount() -> Account?{
        if accounts.count > 0 {
            return accounts.first
        }
        
        return nil
    }
    
    public func saveAllAccounts() {
        DispatchQueue.global().async {
            if let path = self.accountFilePath()  {
                var models = [Account].init()
                for account in self.accounts {
                    if account.isTokenValid() {
                        models.append(account)
                    }
                }
                do {
                    let datasToWrite = try JSONEncoder().encode(models)
                    try datasToWrite.write(to: path)
                } catch {
                    Logger.error("fail to save accounts\(error)")
                }
            }
        }
    }
    
    public func saveAccount(_ account: Account) {
        if !account.isTokenValid() {
            return
        }
        
        accounts.append(account)
        saveAllAccounts()
    }
    
    public func loadAccounts() {
        if let path = self.accountFilePath()  {
            do {
                let datas = try Data.init(contentsOf: path)
                let models = try JSONDecoder().decode([Account].self, from: datas)
                self.accounts = models
                self.saveAllAccounts()
            } catch {
                Logger.error("fail to load accounts\(error)")
            }
        }
    }
    
    func accountFilePath() -> URL? {
        var path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        path?.appendPathComponent("accounts")
        Logger.info("account path:\(path?.absoluteString)")
        return path
    }
}
