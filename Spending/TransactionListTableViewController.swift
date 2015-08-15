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
    
    private var transactionService : TransactionService!
    
    private var resultsController : NSFetchedResultsController!
    
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
        resultsController = transactionService.getSections(account)
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if resultsController == nil || resultsController.sections == nil {
            return 0
        }
        return resultsController.sections!.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if resultsController == nil || resultsController.sections == nil {
            return 0
        }
        return resultsController.sections![section].numberOfObjects
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("transactionCell") as! TransactionTableViewCell
        
        let nsmo = resultsController.sections![indexPath.section].objects![indexPath.row]
        let transaction = nsmo as! Transaction
        
        cell.descriptionLabel.text = transaction.title
        
        let amountFormatter = NSNumberFormatter()
        amountFormatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        
        cell.amountLabel.text = amountFormatter.stringFromNumber(transaction.amount!)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if resultsController == nil || resultsController.sections == nil {
            return ""
        }
        
        let sectionObject = resultsController.sections![section]
        let total = getTotal(sectionObject.objects as! [Transaction])
        
        let numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        
        let firstRow = sectionObject.objects![0] as! Transaction
        
        let formatter = NSDateFormatter()
        //formatter.dateFormat = "yyyy-MM-dd hh:mm:ss Z"
        //formatter.timeZone = NSDate
        
        //let date = formatter.dateFromString(name)

        formatter.dateFormat = "EEEE, d MMM yy"
        return formatter.stringFromDate(firstRow.date!) + " (spent: " + numberFormatter.stringFromNumber(total)! + ")"
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func getTotal(rows: [Transaction]) -> NSDecimalNumber {
        var total : NSDecimalNumber = 0
        for var i = 0; i < rows.count; i++ {
            if rows[i].amount!.integerValue < 0 {
                total = total.decimalNumberByAdding(rows[i].amount!)
            }
        }
        return total.decimalNumberByMultiplyingBy(-1)
    }
    
//
//    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let cell = tableView.dequeueReusableCellWithIdentifier("headerCell") as! TransactionTableHeaderCell
//        
//        let name = resultsController.sections![section].name
//        
//        let formatter = NSDateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss Z"
//        
//        let date = formatter.dateFromString(name)
//        
//        formatter.dateFormat = "EEEE d MMMM yyyy"
//        cell.titleLabel. = formatter.stringFromDate(date!)
//        
//        return cell
//    }
    
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
        let transaction = getTransaction(indexPath)
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
            nvc.transaction = getTransaction(tableView.indexPathForSelectedRow!)
        }
        if segue.identifier == "addTransaction2" {
            let nvc = segue.destinationViewController as! AddTransactionTableViewController
            
            nvc.context = context
            nvc.account = account
        }
    }
    
    func getTransaction(indexPath: NSIndexPath) -> Transaction {
        return resultsController.sections![indexPath.section].objects![indexPath.row] as! Transaction
    }

}
