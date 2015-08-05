//
//  TransactionService.swift
//  Spending
//
//  Created by John Grayson on 5/08/15.
//  Copyright © 2015 John Grayson. All rights reserved.
//

import Foundation
import CoreData

class TransactionService : NSObject {
    
    private var context : NSManagedObjectContext!
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func addTransaction(title: String, amount: NSDecimalNumber, tags: String, date: NSDate, account: Account) -> Transaction? {
        
        let date = NSDate()
        
        let entity =  NSEntityDescription.entityForName("Transaction", inManagedObjectContext: context)
        
        let tran = Transaction(entity: entity!, insertIntoManagedObjectContext:context)
        tran.title = title
        tran.amount = amount
        tran.tags = tags
        tran.date = date
        
        let set = account.mutableSetValueForKey("transactions")
        set.addObject(tran)
        
        do {
            try context.save()
            return tran
        } catch {
            print("Could not save note")
            return nil
        }
    }
    
    func updateTransaction(transaction: Transaction) -> Bool {
        do {
            try context.save()
            return true
        } catch {
            print("Could not save note")
            return false
        }
    }
    
    func getTransactions(account: Account) -> [Transaction] {
        let fetchRequest = NSFetchRequest(entityName:"Transaction")
        
        fetchRequest.predicate = NSPredicate(format: "account = %@", argumentArray: [account])
        
        let sortDate = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDate]
        
        do {
            let fetchedResults = try context.executeFetchRequest(fetchRequest) as! [Transaction]
            
            return fetchedResults
        } catch {
            return [Transaction]()
        }
    }
    
    func deleteTransaction(transaction: Transaction) -> Bool {
        transaction.account?.balance = transaction.account?.balance?.decimalNumberBySubtracting(transaction.amount!)
        
        context.deleteObject(transaction)
        
        do {
            try context.save()
            return true
        } catch {
            print("Could not save")
            return false
        }
    }
}