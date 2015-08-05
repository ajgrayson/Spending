//
//  AccountService.swift
//  Spending
//
//  Created by John Grayson on 5/08/15.
//  Copyright © 2015 John Grayson. All rights reserved.
//

import Foundation
import CoreData

class AccountService : NSObject {
    
    private var context : NSManagedObjectContext!
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func getAccount(name: String) -> Account? {
        let fetchRequest = NSFetchRequest(entityName:"Account")
        
        fetchRequest.predicate = NSPredicate(format: "name = %@", argumentArray: [name])
        
        do {
            let fetchedResults = try context.executeFetchRequest(fetchRequest) as! [Account]
            
            if fetchedResults.count > 0 {
                return fetchedResults.first!
            }
            
            return nil
        } catch {
            return nil
        }
    }
    
    func getBalance(name: String) -> NSDecimalNumber! {
        let account = getAccount(name)
        
        if account != nil {
            return account!.balance
        }
        return nil
    }
    
    func addAccount(name: String) -> Account? {
        let date = NSDate()
        
        let entity =  NSEntityDescription.entityForName("Account", inManagedObjectContext: context)
        
        let account = Account(entity: entity!, insertIntoManagedObjectContext:context)
        account.name = name
        account.balance = 0
        account.lastUpdatedDate = date
        
        do {
            try context.save()
            return account
        } catch {
            print("Could not save note")
            return nil
        }
    }
    
    func updateAccount(account: Account) -> Bool {
        account.lastUpdatedDate = NSDate()
        
        do {
            try context.save()
            return true
        } catch {
            print("Could not save note")
            return false
        }
    }
}