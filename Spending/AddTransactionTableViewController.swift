//
//  AddTransactionTableViewController.swift
//  Spending
//
//  Created by John Grayson on 5/08/15.
//  Copyright © 2015 John Grayson. All rights reserved.
//

import UIKit
import CoreData

class AddTransactionTableViewController: UITableViewController {

    @IBOutlet weak var typeSwitch: UISwitch!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var tagsTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func saveButtonClicked(sender: UIBarButtonItem) {
        if save() {
            navigationController?.popViewControllerAnimated(true)
        }
    }
    
    var context : NSManagedObjectContext!
    
    var account : Account!
    
    var transaction : Transaction!
    
    private var transactionService : TransactionService!
    
    private var accountService : AccountService!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        transactionService = TransactionService(context: context)
        accountService = AccountService(context: context)
        
        loadTransaction()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadTransaction() {
        if transaction != nil {
            descriptionTextField.text = transaction.title
            
            let formatter = NSNumberFormatter()
            formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
            
            var amount = transaction.amount!
            
            if transaction.amount?.doubleValue > 0 {
                typeSwitch.setOn(true, animated: false)
            } else {
                typeSwitch.setOn(false, animated: false)
                amount = amount.decimalNumberByMultiplyingBy(-1)
            }
            typeSwitch.enabled = false
            
            amount.decimalNumberByMultiplyingBy(-1)
            amountTextField.text = formatter.stringFromNumber(amount)!
            
            tagsTextField.text = transaction.tags
            datePicker.date = transaction.date!
        }
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.selectionStyle = UITableViewCellSelectionStyle.None
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    func save() -> Bool {
        if isEmpty(descriptionTextField) || isEmpty(amountTextField) {
            return false
        }
        
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        let decimalAmount = formatter.numberFromString(amountTextField.text!)?.decimalValue
        var amount = NSDecimalNumber(decimal: decimalAmount!)
        
        if !typeSwitch.on {
            amount = amount.decimalNumberByMultiplyingBy(-1)
        }
        
        if transaction == nil {
            transactionService.addTransaction(descriptionTextField.text!, amount: amount, tags: tagsTextField.text!, date: datePicker.date, account: account)
            
            account.balance = account.balance?.decimalNumberByAdding(amount)
        } else {
            let oldAmount = transaction.amount
            let diff = amount.decimalNumberBySubtracting(oldAmount!)
            
            account.balance = account.balance?.decimalNumberByAdding(diff)
            
            transaction.title = descriptionTextField.text
            transaction.tags = tagsTextField.text
            transaction.amount = amount
            transaction.date = datePicker.date
            
            transactionService.updateTransaction(transaction)
        }
        
        accountService.updateAccount(account)
        
        return true
    }
    
    func isEmpty(field: UITextField) -> Bool {
        return field.text == nil || field.text == ""
    }

}
