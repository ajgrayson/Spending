//
//  TransactionTableHeaderCell.swift
//  Spending
//
//  Created by John Grayson on 15/08/15.
//  Copyright © 2015 John Grayson. All rights reserved.
//

import UIKit

class TransactionTableHeaderCell: UITableViewHeaderFooterView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
