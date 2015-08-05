//
//  TransactionListTableViewController.swift
//  Spending
//
//  Created by John Grayson on 5/08/15.
//  Copyright © 2015 John Grayson. All rights reserved.
//

import UIKit
import CoreData

class TransactionListTableViewController: UITableViewController {
    
    var context : NSManagedObjectContext!
    
    var account : Account!
    
    private var transactions : [Transaction]!
    
    private var transactionService : TransactionService!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        transactionService = TransactionService(context: context)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadTransactions()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadTransactions() {
        transactions = transactionService.getTransactions(account)
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("transactionCell") as! TransactionTableViewCell
        
        let transaction = transactions[indexPath.row]
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEEE, d MMMM YYYY"
        
        cell.descriptionLabel.text = transaction.title
        cell.dateLabel.text = formatter.stringFromDate(transaction.date!)
        
        let amountFormatter = NSNumberFormatter()
        amountFormatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        
        cell.amountLabel.text = amountFormatter.stringFromNumber(transaction.amount!)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction] {
        
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete") {
            (action, indexPath) -> Void in
            self.deleteRow(indexPath)
        }
        
        return [deleteAction]
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func deleteRow(indexPath: NSIndexPath) {
        let transaction = transactions[indexPath.row]
        displayDeleteConfirmation(transaction)
    }
    
    func displayDeleteConfirmation(tranaction: Transaction) {
        let alert = UIAlertController(title: "Delete",
            message: "Are you sure you want to delete this transaction.",
            preferredStyle: .Alert)
        
        alert.addAction(UIAlertAction(title: "Yes",
            style: .Default,
            handler: { action in
                self.deleteTransaction(tranaction)
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .Cancel, handler: {
            action in
            self.tableView.setEditing(false, animated: true)
        }))
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func deleteTransaction(transaction: Transaction) {
        transactionService.deleteTransaction(transaction)
        loadTransactions()
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editTransaction" {
            let nvc = segue.destinationViewController as! AddTransactionTableViewController
            
            nvc.context = context
            nvc.account = account
            nvc.transaction = transactions[tableView.indexPathForSelectedRow!.row]
        }
        if segue.identifier == "addTransaction2" {
            let nvc = segue.destinationViewController as! AddTransactionTableViewController
            
            nvc.context = context
            nvc.account = account
        }
    }

}
