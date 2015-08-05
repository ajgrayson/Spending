//
//  Transaction+CoreDataProperties.swift
//  Spending
//
//  Created by John Grayson on 5/08/15.
//  Copyright © 2015 John Grayson. All rights reserved.
//
//  Delete this file and regenerate it using "Create NSManagedObject Subclass…"
//  to keep your implementation up to date with your model.
//

import Foundation
import CoreData

extension Transaction {

    @NSManaged var title: String?
    @NSManaged var date: NSDate?
    @NSManaged var tags: String?
    @NSManaged var amount: NSDecimalNumber?
    @NSManaged var account: Account?

}
