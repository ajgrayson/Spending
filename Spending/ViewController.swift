//
//  ViewController.swift
//  Spending
//
//  Created by John Grayson on 5/08/15.
//  Copyright © 2015 John Grayson. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var amountLabel: UILabel!
    
    var context : NSManagedObjectContext!
    
    var account : Account!
    
    private var accountService : AccountService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        accountService = AccountService(context: context)
        
        if accountService.getAccount("main") == nil {
            account = accountService.addAccount("main")
        }
        
        account = accountService.getAccount("main")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        loadBalance()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadBalance() {
        let balance = accountService.getBalance("main")
        
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        
        amountLabel.text = formatter.stringFromNumber(balance!)!
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addTransaction" {
            let nvc = segue.destinationViewController as! AddTransactionTableViewController
            
            nvc.context = context
            nvc.account = account
        }
        if segue.identifier == "viewTransactions" {
            let nvc = segue.destinationViewController as! TransactionListTableViewController
            
            nvc.context = context
            nvc.account = account
        }
    }

}

