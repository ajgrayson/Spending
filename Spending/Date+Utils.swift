//
//  Date+Utils.swift
//  Spending
//
//  Created by John Grayson on 15/08/15.
//  Copyright © 2015 John Grayson. All rights reserved.
//

import Foundation

extension NSDate {
    func dateWithoutTime() -> NSDate {
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        let components = calendar!.components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.TimeZone], fromDate: self)
        
        return calendar!.dateFromComponents(components)!
    }
}