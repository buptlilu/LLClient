//
//  AccountManager.swift
//  LLAccount
//
//  Created by lilu on 2022/4/1.
//

import Foundation


public class AccountManager: NSObject {
    public static var shared = AccountManager.init()
    
    var accounts: [Account] = []
    
    public override init() {
        super.init()
        accounts = allAccounts()
    }
    
    public func allAccounts() -> [Account]{
        var accounts = [Account].init()
        //todo
        return accounts
    }
    
    public func topAccount() -> Account?{
        if accounts.count > 0 {
            return accounts.first
        }
        
        return nil
    }
    
    public func saveAllAccounts() {
        //todo
    }
    
    public func saveAccount(_ account: Account) {
        if !account.isTokenValid() {
            return
        }
        
        accounts.append(account)
        saveAllAccounts()
    }
}
